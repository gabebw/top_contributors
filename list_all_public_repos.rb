#!/usr/bin/env ruby

begin
  require 'octokit'
rescue LoadError
  STDERR.puts "!! Error: octokit is not installed, do `gem install octokit`"
  exit 1
end

ORGANIZATION = ARGV[0]
TOKEN = ARGV[1]

# Auto-paginates up to 100 pages of (by default) 30 items/page.
Octokit.auto_paginate = true

client = Octokit::Client.new(
  login: TOKEN,
  password: 'x-oauth-basic'
)

begin
  puts client.repositories(ORGANIZATION).map { |repo| repo[:name] }
rescue Octokit::Unauthorized
  STDERR.puts "Bad credentials - is your GitHub token valid?"
  exit 1
end
