require 'sidekiq'
require 'sidekiq-failures'

redis_options = { url: NotifyMe::Config.app.redis.url, namespace: 'notify-me' }

Sidekiq.configure_client do |config|
  # DCell.start id: 'sidekiq_client', addr: "tcp://127.0.0.1:#{NotifyMe::RandomPort.new.next_available}"
  config.redis = redis_options
end

Sidekiq.configure_server do |config|
  # DCell.start id: 'sidekiq_server', addr: "tcp://127.0.0.1:#{NotifyMe::RandomPort.new.next_available}"
  config.redis = redis_options
end
