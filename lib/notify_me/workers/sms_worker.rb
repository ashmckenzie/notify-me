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
          from:   Config.app.twilio.caller_id,
          to:     opts['to'],
          body:   body
        )
      end

      private

        def twilio
          @twilio ||= Twilio::REST::Client.new(Config.app.twilio.sid, Config.app.twilio.auth_token)
        end

        def body
          "%s\n\n%s" % [ opts['title'], opts['message'] ]
        end
    end
  end
end
