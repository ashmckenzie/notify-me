require 'sidekiq'
require 'twilio-ruby'

module NotifyMe
  module Workers
    class SmsWorker

      include Sidekiq::Worker

      QUEUE_NAME = :high
      sidekiq_options :queue => QUEUE_NAME

      def perform opts
        twilio.account.messages.create(
          from:   config.caller_id,
          to:     opts['to'],
          body:   body(opts)
        )
      end

      private

        def config
          Config.app.services.twilio
        end

        def twilio
          @twilio ||= Twilio::REST::Client.new(config.sid, config.auth_token)
        end

        def body opts
          "%s\n%s\n%s\n%s" % [ opts['host'], opts['time'], opts['title'], opts['message'] ]
        end
    end
  end
end
