# frozen_string_literal: true

require 'socket'
require 'sequel'
require 'yaml'

env = ARGV.first
server_id = ARGV[1]

Sequel.connect(YAML.load(File.read(File.join(__dir__, '..', 'config', 'database.yml')))[env]) do |db|
  STDIN.gets
  while (data = STDIN.gets.chomp)
    ping_time = data.split('=').last
    if ping_time.end_with?(' ms')
      ping_time.delete!(' ms')
    else
      ping_time = nil
    end
    db[:pings].insert(server_id: server_id, ping_time: ping_time)
  end
end
