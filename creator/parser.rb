#!/usr/bin/env ruby

require 'rubygems'
require 'mongo'

module TokenType
  CLASS_NAME = 10
  METHOD_NAME = 20
  VARIABLE_NAME = 30
end

class RubyParser
  require 'ripper'

  def self.extract_names(code)
    sexps = Ripper.sexp(code) || []
    extract_names_from_sexps(sexps)
  end

  private

  def self.extract_names_from_sexps(sexps)
    names = []
    sexps.each { |sexp|
      next if sexp.class != Array

      if [:var_field, :def, :defs, :class, :module].include? sexp[0]
        names << [convert_token_type(sexp[0]), extract_name(sexp)]
      end
      if sexp[0] == :params
        names += extract_params(sexp)
      end

      if sexp.class == Array
        names += extract_names_from_sexps(sexp)
      end
    }
    names
  end

  def self.extract_params(sexps)
    names = []
    sexps.each { |sexp|
      next unless sexp.class == Array

      if [:@ident, :@label].include?(sexp[0])
        names << [TokenType::VARIABLE_NAME, sexp[1]]
      end

      names += extract_params(sexp)
    }
    names
  end

  def self.convert_token_type(type)
    if [:class, :module].include? type
      TokenType::CLASS_NAME
    elsif [:def, :defs].include? type
      TokenType::METHOD_NAME
    else
      TokenType::VARIABLE_NAME
    end
  end

  def self.extract_name(sexps)
    # ちょっとゴリ押し
    sexps.each { |sexp|
      next if sexp.class != Array

      if [:@ident, :@const, :@ivar, :@gvar].include? sexp[0]
        return sexp[1].gsub(/^\$|^@/, "")
      end
      if sexp[0] == :const_ref
        return sexp[1][1]
      end
    }
    nil
  end
end

def register_result(result)
  @settings ||= YAML.load_file('./database.yml')
  @client ||= Mongo::Client.new(@settings['database_url'])
  @collection ||= @client[:names]

  @collection.insert_one(result)
end


BASE_DIR=File.dirname(__FILE__)
TARGET_DIR="#{BASE_DIR}/data"

Dir::glob("#{TARGET_DIR}/**/*.rb") { |filename|
  next unless File.file?(filename)
  relative_path = filename.gsub(/#{TARGET_DIR}/, "").scan(/^\/(.+?)\/(.+?)\/(.+?)$/)[0]
  repository = "#{relative_path[0]}/#{relative_path[1]}"
  src_name   = "#{relative_path[2]}"

  puts "#{repository}: #{src_name}"
  names = RubyParser.extract_names(File.read(filename))
  names.each { |name|
    data = {
      :repository => repository,
      :filename => src_name,
      :type => name[0],
      :name => name[1]
    }
    register_result(data) if name[1]
  }
}


