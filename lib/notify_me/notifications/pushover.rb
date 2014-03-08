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

        attr_reader :notification, :recipient

        def options
          {
            user_key:   recipient.user_key,
            api_token:  recipient.api_token,
            title:      notification.title,
            message:    notification.message,
            host:       notification.host,
            time:       notification.time
          }
        end
    end
  end
end
