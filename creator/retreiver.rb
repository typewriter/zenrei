#!/usr/bin/env ruby

require 'json'

if ARGV.size < 1
  STDERR.puts "./retreiver.rb LANGUAGE"
  exit
end

LANG=ARGV[0]

SLEEP_INTERVAL = 120
BASE_DIR = File.dirname(__FILE__)
WORKING_DIR = "#{BASE_DIR}/#{LANG}"
Dir::mkdir(WORKING_DIR) if !Dir.exists?(WORKING_DIR)

def update_repository_list
  puts "update repository list..."
  repositories = nil
  1.upto(100) { |page_index|
    print "page #{page_index}: "

    #url = "https://api.github.com/search/repositories?q=stars%3A>1&sort=stars&order=desc&page=#{page_index}"
    url = "https://api.github.com/search/repositories?q=language%3A#{LANG}&sort=stars&order=desc&page=#{page_index}"
    repos = JSON.parse(`curl "#{url}"`)

    break if !repos || !repos["items"]

    if repositories
      repositories["items"] += repos["items"]
    else
      repositories = repos
    end

    puts "#{repositories["items"].count}..."
    sleep 10
  }
  File.open("#{WORKING_DIR}/repositories.json", "w") { |f| f.print repositories.to_json }
end

def read_repository_list
  JSON.parse(File.read("#{WORKING_DIR}/repositories.json"))["items"]
end

def clone_or_pull_repositories(repository_list)
  repository_list.each { |repository|
    clone_name = repository["full_name"]
    clone_url  = repository["clone_url"]
    clone_path = "#{WORKING_DIR}/#{clone_name}"

    if Dir.exists?(clone_path)
      puts "cd #{clone_path} && git pull"
      `cd #{clone_path} && git pull`
    else
      puts "git clone --depth 1 #{clone_url} #{clone_path}"
      `git clone --depth 1 #{clone_url} #{clone_path}`
    end

    sleep SLEEP_INTERVAL * (1+rand*2)
  }
end

update_repository_list
repositories = read_repository_list
clone_or_pull_repositories(repositories)

