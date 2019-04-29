# frozen_string_literal: true

require 'grape'
require 'grape-swagger'
require 'sequel'
require 'yaml'

module PingStats
  DB = Sequel.connect(
    YAML.load(File.read(File.join(__dir__, 'config', 'database.yml')))[ENV['RACK_ENV'] || 'development']
  )
  Dir[*%w[lib models services].map { |d| File.join(__dir__, d, '**', '*.rb') }].each { |f| require f }

  class Api < Grape::API
    format :json

    helpers do
      params :requires_ip_address do
        requires :ip_address, type: String, desc: "Server's IP address in dot-decimal notation"
      end
    end

    desc 'Get ping stats'

    params do
      use :requires_ip_address
      requires :start_interval, type: Time, desc: 'Start of time interval'
      requires :end_interval, type: Time, desc: 'End of time interval'
    end

    get '/' do
      StatsService.new(params[:ip_address], params[:start_interval], params[:end_interval]).call || status(404)
    end

    desc "Add server's IP address to stats"

    params { use :requires_ip_address }

    post '/' do
      AddService.new(params[:ip_address]).call
    end

    desc "Remove server's IP address from stats"

    params { use :requires_ip_address }

    delete '/' do
      RemoveService.new(params[:ip_address]).call || status(404)
    end

    add_swagger_documentation
  end
end
