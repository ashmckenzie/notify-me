module NotifyMe
  module Notifications
    class Sms

      def initialize notification, recipient
        @notification = notification
        @recipient = recipient
      end

      def notify!
        Workers::SmsWorker.perform_async(options)
      end

      private

        attr_reader :notification, :recipient

        def options
          {
            to:       recipient.to,
            title:    notification.title,
            message:  notification.message,
            host:     notification.host,
            time:     notification.time
          }
        end
    end
  end
end
