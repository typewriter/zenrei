import parser from '@babel/parser';
import fs from 'fs';

const filename = process.argv[2];
console.log(filename);

const source   = fs.readFileSync(filename, 'utf-8');

function append(a, b) {
  b.forEach(n => a.push(n));
}

function extractParams(params, results) {
  params.forEach(n => {
    if (n.type === 'Identifier') {
      results.push({ type: 'params', name: n.name });
    }
  });
}

function traverseNode(node, results, parentNode) {
  console.log(node);
  if (node instanceof Array) {
    node.forEach(n => traverseNode(n, results));
  }
  if (node.body) {
    traverseNode(node.body, results);
  }
  if (node.block) {
    traverseNode(node.block, results);
  }
  if (node.handler) {
    traverseNode(node.handler, results);
  }
  if (node.finalizer) {
    traverseNode(node.finalizer, results);
  }
  if (node.argument) {
    traverseNode(node.argument, results);
  }
  if (node.params) {
    extractParams(node.params, results);
  }
  if (node.expression) {
    traverseNode(node.expression, results);
  }
  if (node.arguments) {
    traverseNode(node.arguments, results);
  }
  if (node.elements) {
    traverseNode(node.elements, results);
  }
  if (node.declarations) {
    traverseNode(node.declarations, results);
  }
  if (node.declaration) {
    traverseNode(node.declaration, results);
  }
  if (node.type === 'MemberExpression' && node.property &&
      parentNode && parentNode.type === 'AssignmentExpression') {
    results.push({ type: 'variable', name: node.property.name });
  }
  if (node.type === 'VariableDeclarator') {
    if (node.id.name) {
      results.push({ type: 'variable', name: node.id.name });
    }
    if (node.id.properties) {
      traverseNode(node.id.properties, results);
    }
  }
  if (node.consequent) {
    traverseNode(node.consequent, results);
  }
  if (node.left) {
    traverseNode(node.left, results, node);
  }
  if (node.right) {
    traverseNode(node.right, results);
  }
  if (node.init) {
    traverseNode(node.init, results);
  }
  if (node.properties) {
    traverseNode(node.properties, results);
  }
  if (node.value) {
    traverseNode(node.value, results);
  }
  if (node.type === 'ClassDeclaration' && node.id) {
    results.push({ type: 'class', name: node.id.name });
  }
  if (node.type === 'ClassMethod' && node.key) {
    results.push({ type: 'static method', name: node.key.name });
  }
  if (node.type === 'FunctionDeclaration' && node.id) {
    results.push({ type: 'method', name: node.id.name });
  }
  if (node.type === 'ObjectProperty' && node.key) {
    results.push({ type: 'key', name: node.key.name || node.key.value });
  }
}

const node = parser.parse(source, { sourceType: 'unambiguous' }).program.body;
var results = [];
traverseNode(node, results);
console.log(results);

