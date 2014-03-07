module NotifyMe
  module Notifications
    class Pushover

      def initialize notification, recipient
        @notification = notification
        @recipient = recipient
      end

      def notify!
        Workers::PushoverWorker.perform_async(options)
      end

      private

        attr_reader :notification

        def options
          {
            user_key: recipient.user_key,
            api_token: recipient.api_token,
            message: notification.message,
            title: notification.title
          }
        end
    end
  end
end
