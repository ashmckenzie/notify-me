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
            subject:    subject,
            html:       html
          }
        end

        def subject
          "[priority: %{priority}] [category: %{category}] %{title}" % { title: notification.title, category: notification.category, priority: notification.priority }
        end

        def html
          content = Hashie::Mash.new({ notification: notification })
          Slim::Template.new('./lib/notify_me/templates/email.html.slim').render(content)
        end
    end
  end
end
