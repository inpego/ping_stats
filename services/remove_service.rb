module PingStats
  class RemoveService
    def initialize(ip_address)
      @server = Server.find(ip_address: ip_address)
    end

    def call
      return unless @server

      @server.update(enabled: false)
      Processor.new(server: @server).stop
    end
  end
end