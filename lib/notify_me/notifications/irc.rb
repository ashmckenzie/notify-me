module NotifyMe
  module Notifications
    class Irc

      def initialize notification, recipient
        @notification = notification
        @recipient = recipient
      end

      def notify!
        # FIXME

        # if NotifyMe::Daemons::Irc.connected?
          Workers::IrcWorker.perform_async(options)
        # else
          # Workers::IrcWorker.perform_in(60, options)
        # end
      end

      private

        attr_reader :notification, :recipient

        def options
          {
            nicknames:  recipient.nicknames,
            title:      notification.title,
            message:    notification.message,
            host:       notification.host,
            time:       notification.time
          }
        end
    end
  end
end
