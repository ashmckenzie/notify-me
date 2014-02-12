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
          from_email:   opts['from'],
          html:         opts['html']
        )
      end

      private

        def mandrill
          @mandrill ||= Mandrill::API.new(Config.app.mandrill.api_key, false)
        end
    end
  end
end
