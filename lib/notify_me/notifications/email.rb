require 'slim'

module NotifyMe
  module Notifications
    class Email

      def initialize notification
        @notification = notification
      end

      def notify!
        Workers::EmailWorker.perform_async(options)
      end

      private

        attr_reader :notification

        def options
          {
            to:         'ash@the-rebellion.net',
            from:       'ash@the-rebellion.net',
            from_email: 'Notify Me <ash@the-rebellion.net>',
            subject:    notification.subject,
            html:       html
          }
        end

        def html
          content = Hashie::Mash.new({ notification: notification })
          Slim::Template.new(notification.email_template).render(content)
        end
    end
  end
end
