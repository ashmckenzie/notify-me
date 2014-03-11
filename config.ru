# encoding: UTF-8

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

require 'sidekiq/web'
require './app/errors'
require './app/user'
require './app/result'
require './app/web_app'

# DCell.start id: 'sinatra_app', addr: "tcp://127.0.0.1:#{NotifyMe::RandomPort.new.next_available}"

run Rack::URLMap.new(
  '/' => NotifyMe::WebApp,
  '/sidekiq' => Sidekiq::Web
)
