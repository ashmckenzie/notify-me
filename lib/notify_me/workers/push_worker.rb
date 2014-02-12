require 'sidekiq'
require 'mandrill'
require 'pushover'

module NotifyMe
  module Workers
    class PushWorker

      include Sidekiq::Worker

      QUEUE_NAME = :high
      sidekiq_options :queue => QUEUE_NAME

      def perform opts
        Pushover.notification(
          message:  opts['message'],
          title:    opts['title'],
          user:     Config.app.pushover.user_key,
          token:    Config.app.pushover.api_token
        )
      end
    end
  end
end
