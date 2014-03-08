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
          message:  message(opts),
          title:    opts['title'],
          user:     opts['user_key'],
          token:    opts['api_token']
        )
      end

      private

        def message opts
          "Host: %s\nTime: %s, Message: %s" % [ opts['host'], opts['time'], opts['message'] ]
        end
    end
  end
end
