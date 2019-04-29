# frozen_string_literal: true

require 'sequel'
require 'yaml'

env = ARGV.first || 'development'
ENV['RACK_ENV'] ||= env
DB = Sequel.connect(YAML.load(File.read(File.join(__dir__, '..', 'config', 'database.yml')))[env])

require_relative '../models/server'
require_relative '../models/ping'
require_relative '../lib/processor'

PingStats::Processor.restart_all
