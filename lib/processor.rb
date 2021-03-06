# frozen_string_literal: true

module PingStats
  class Processor
    attr_reader :server

    def self.restart_all
      Server.where(enabled: true).each do |server|
        new(server: server).start if `ps ax | grep '[p]ing #{server.ip_address}'`.empty?
      end
    end

    def initialize(ip_address: nil, server: nil)
      @server = server || Server.find(ip_address: ip_address)
    end

    def start
      collector_path = File.join(__dir__, '../scripts/collector.rb')
      collector_cmd = "~/.rvm/bin/rvm default do bundle exec ruby #{collector_path} #{ENV['RACK_ENV']} #{server.id}"
      system("(ping #{server.ip_address} 2>&1 | #{collector_cmd} &)")
    end

    def stop
      `kill $(ps ax | grep '[c]ollector.rb #{ENV['RACK_ENV']} #{server.id}' | awk '{ print $1 }')`
    end
  end
end
