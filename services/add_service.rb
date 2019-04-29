# frozen_string_literal: true

module PingStats
  class AddService
    attr_reader :ip_address

    def initialize(ip_address)
      @ip_address = ip_address
    end

    def call
      Server.update_or_create({ ip_address: ip_address }, enabled: true)
      Processor.new(ip_address: ip_address).start
    end
  end
end
