#!/usr/bin/env ruby

require 'json'

SLEEP_INTERVAL = 120
BASE_DIR = File.dirname(__FILE__)
WORKING_DIR = "#{BASE_DIR}/data"
Dir::mkdir(WORKING_DIR) if !Dir.exists?(WORKING_DIR)

def update_repository_list
  1.upto(1) { |page_index|
    #url = "https://api.github.com/search/repositories?q=stars%3A>1&sort=stars&order=desc&page=#{page_index}"
    url = "https://api.github.com/search/repositories?q=language%3ARuby&sort=stars&order=desc&page=#{page_index}"
    `curl "#{url}" > #{WORKING_DIR}/repositories.json`
  }
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

    sleep SLEEP_INTERVAL
  }
end

update_repository_list
repositories = read_repository_list
clone_or_pull_repositories(repositories)

