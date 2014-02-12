require 'sidekiq'
require 'sidekiq-failures'

redis_options = { url: NotifyMe::Config.instance.redis.url, namespace: 'notify-me' }

Sidekiq.configure_client do |config|
  config.redis = redis_options
end

Sidekiq.configure_server do |config|
  config.redis = redis_options
end
