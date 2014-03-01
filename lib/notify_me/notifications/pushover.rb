module NotifyMe
  module Notifications
    class Pushover

      def initialize notification
        @notification = notification
      end

      def notify!
        Workers::PushWorker.perform_async(options)
      end

      private

        attr_reader :notification

        def options
          { message: notification.message, title: notification.title }
        end
    end
  end
end
