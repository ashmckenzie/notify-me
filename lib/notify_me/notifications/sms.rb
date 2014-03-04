module NotifyMe
  module Notifications
    class Sms

      def initialize notification
        @notification = notification
      end

      def notify!
        Workers::SmsWorker.perform_async(options)
      end

      private

        attr_reader :notification

        def options
          { to: '+61417365255', title: notification.title, message: notification.message }
        end
    end
  end
end
