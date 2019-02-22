#!/usr/bin/env ruby

require 'rubygems'
require 'mongo'

settings = YAML.load_file('../database.yml')
client = Mongo::Client.new(settings['database_url'])
collection_names = client[:names]
collection_counters = client[:counters]

# 全レコード削除
collection_counters.delete_many()

# TokenTypeを区別しない
results = collection_names.aggregate([
  '$group': { '_id': '$name', 'count': { '$sum': 1 }}
])
results.each { |result|
  record = { name: result['_id'], type: nil, count: result['count'] }
  collection_counters.insert_one(record)
}

# TokenTypeを区別する
results = collection_names.aggregate([
  '$group': { '_id': { 'name': '$name', 'type': '$type' }, 'count': { '$sum': 1 }}
])
results.each { |result|
  record = { name: result['_id']['name'], type: result['_id']['type'], count: result['count'] }
  collection_counters.insert_one(record)
}
