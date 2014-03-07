require 'sidekiq'
require 'pushover'

module NotifyMe
  module Workers
    class PushoverWorker

      include Sidekiq::Worker

      QUEUE_NAME = :high
      sidekiq_options :queue => QUEUE_NAME

      def perform opts
        Pushover.notification(
          message:  opts['message'],
          title:    opts['title'],
          user:     opts['user_key'],
          token:    opts['api_token']
        )
      end
    end
  end
end
