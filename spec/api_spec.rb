# frozen_string_literal: true

require 'rack/test'
require 'active_support/testing/time_helpers'
require_relative '../api'

describe PingStats::Api, type: :request do
  include Rack::Test::Methods
  include ActiveSupport::Testing::TimeHelpers

  around(:each) do |example|
    PingStats::DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end

  def app
    PingStats::Api
  end

  let(:ip_address) { '8.8.4.4' }

  describe 'GET /' do
    let(:interval) { '2019-04-27 22:42:33' }

    context 'when server exists' do
      before do
        server = Server.create(ip_address: ip_address)
        [39.9, 67.3, 205, 43.6, 46.8, 55.9, 42.3, 42.3, 42.0, 145,
         45.7, 46.1, 45.9, 46.8, 46.1, 42.4, 42.1, 43.5, 39.3, 44.3].each do |ping_time|
          server.add_ping(ping_time: ping_time, created_at: interval)
        end
        5.times { server.add_ping(created_at: interval) }

        [39.9, 67.3, 205, 43.6, 46.8, 55.9, 42.3, 42.3, 42.0, 145].each do |ping_time|
          server.add_ping(ping_time: ping_time)
        end
        get '/', ip_address: ip_address, start_interval: interval, end_interval: interval
      end

      subject { JSON.parse(last_response.body).symbolize_keys }

      it 'returns correct min//max/avg/stddev/lost stats' do
        is_expected.to eq(avg: 58.62, min: 39.3, max: 205, median: 45, stddev: 41.44, lost: 20)
      end
    end

    context 'when server does not exist' do
      before { get '/', ip_address: ip_address, start_interval: interval, end_interval: interval }

      it('returns 404 Not Found') { expect(last_response.status).to eq(404) }
    end
  end

  describe 'POST /' do
    context 'when server does not exist' do
      it 'creates server' do
        expect { post '/', ip_address: ip_address }.to change(Server, :count).by(1)
        expect(Server.last.enabled).to be true
      end
    end

    context 'when server exists' do
      before do
        Server.create(ip_address: ip_address)
      end

      it 'enables server' do
        expect { post '/', ip_address: ip_address }.to change { Server.last.enabled }.from(false).to(true)
      end
    end
  end

  describe 'DELETE /' do
    context 'when server does not exist' do
      before { delete '/', ip_address: ip_address }

      it('returns 404 Not Found') { expect(last_response.status).to eq(404) }
    end

    context 'when server exists' do
      before do
        Server.create(ip_address: ip_address, enabled: true)
      end

      it 'disables server' do
        expect { delete '/', ip_address: ip_address }.to change { Server.last.enabled }.from(true).to(false)
      end
    end
  end
end
