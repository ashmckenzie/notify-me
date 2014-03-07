# encoding: UTF-8

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

require 'sidekiq/web'
require './app/errors'
require './app/user'
require './app/result'
require './app/web_app'

run Rack::URLMap.new(
  '/' => NotifyMe::WebApp,
  '/sidekiq' => Sidekiq::Web
)
