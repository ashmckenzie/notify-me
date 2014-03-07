require 'sidekiq'
require 'mandrill'

module NotifyMe
  module Workers
    class EmailWorker

      include Sidekiq::Worker

      QUEUE_NAME = :high
      sidekiq_options :queue => QUEUE_NAME

      def perform opts
        mandrill.messages.send(
          to:           [ { 'email' => opts['to'] } ],
          subject:      opts['subject'],
          from:         config.from,
          from_email:   config.from_email,
          html:         opts['html']
        )
      end

      private

        def config
          Config.app.services.mandrill
        end

        def mandrill
          @mandrill ||= Mandrill::API.new(config.api_key, false)
        end
    end
  end
end
