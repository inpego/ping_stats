# frozen_string_literal: true

module PingStats
  class StatsService
    def initialize(ip_address, start_datetime, end_datetime)
      @server = Server.find(ip_address: ip_address)
      @conditions = { created_at: start_datetime..end_datetime }
    end

    def call
      return unless @server

      @count = @server.pings_dataset.where(@conditions).count
      return if @count.zero?

      @successfull_count = @server.pings_dataset.where(@conditions).count(:ping_time)

      fetch_stats
    end

    private

    def fetch_stats
      {
        avg: @server.pings_dataset.where(@conditions).avg(:ping_time),
        min: @server.pings_dataset.where(@conditions).min(:ping_time),
        max: @server.pings_dataset.where(@conditions).max(:ping_time),
        median: median,
        stddev: @server.pings_dataset.where(@conditions).send(:_aggregate, :stddev_samp, :ping_time).round(2),
        lost: lost
      }
    end

    def median
      limit = @successfull_count.even? ? 2 : 1
      offset = (@successfull_count - limit) / 2
      pings = @server.pings_dataset.where(@conditions).exclude(ping_time: nil).order(:ping_time).limit(limit, offset)
      @successfull_count.even? ? (pings.map { |ping| ping[:ping_time] }.sum / 2).round(2) : pings.first[:ping_time]
    end

    def lost
      ((@successfull_count < @count ? 1 - @successfull_count / @count.to_f : 0) * 100).round(2)
    end
  end
end
