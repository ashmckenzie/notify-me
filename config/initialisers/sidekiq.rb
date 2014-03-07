require 'sidekiq'
require 'sidekiq-failures'

redis_options = { url: NotifyMe::Config.app.redis.url, namespace: 'notify-me' }

Sidekiq.configure_client do |config|
  config.redis = redis_options
end

Sidekiq.configure_server do |config|
  NotifyMe::Daemons::Irc.connect_async!    # FIXME: this is not cool :(
  config.redis = redis_options
end
