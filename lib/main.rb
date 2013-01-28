#! /user/bin/env ruby
# -*- mode:ruby; coding:utf-8 -*-

require 'json'
require 'open-uri'
require 'redis'

$: << "."

ASAKUSA_SATELLITE_ENTRY_POINT = ENV["ASAKUSA_SATELLITE_ENTRY_POINT"]
ASAKUSA_SATELLITE_API_KEY = ENV["ASAKUSA_SATELLITE_API_KEY"]
ASAKUSA_SATELLITE_ROOM_ID = ENV["ASAKUSA_SATELLITE_ROOM_ID"]
REDIS_URL = ENV["REDISTOGO_URL"]
COUNT = 50

uri = URI.parse(REDIS_URL)
redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

loop do

  since_id = redis.get("since_id")

  url = "#{ASAKUSA_SATELLITE_ENTRY_POINT}/message/list.json"
  url += "?api_key=#{ASAKUSA_SATELLITE_API_KEY}"
  url += "&room_id=#{ASAKUSA_SATELLITE_ROOM_ID}"
  url += "&count=#{COUNT}"
  url += "&since_id=#{since_id}" if since_id

  messages = []
  begin
    open(url) do |f|
      messages = JSON.load(f).map { |m| m["view"] = nil; m }
    end
  rescue => e
    warn e
  end

  messages.shift

  messages.each do |m|
    puts "@[heroku.message] " + m.to_json.gsub("\n", "")
    since_id = m["id"]
  end

  redis.set("since_id", since_id)

  sleep 300

end
