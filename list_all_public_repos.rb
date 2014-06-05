#!/usr/bin/env ruby

require 'octokit'

ORGANIZATION = ARGV[0]
TOKEN = ARGV[1]

# Auto-paginates up to 100 pages of (by default) 30 items/page.
Octokit.auto_paginate = true

client = Octokit::Client.new(
  login: TOKEN,
  password: 'x-oauth-basic'
)

puts client.repositories(ORGANIZATION).map { |repo| repo[:name] }
