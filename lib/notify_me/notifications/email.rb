require 'slim'

module NotifyMe
  module Notifications
    class Email

      def initialize notification, recipient
        @notification = notification
        @recipient = recipient
      end

      def notify!
        Workers::EmailWorker.perform_async(options)
      end

      private

        attr_reader :notification, :recipient

        def config
          Config.app.services.mandrill
        end

        def options
          {
            to:       recipient.to,
            subject:  "%s: %s" % [ 'Ding Dong', notification.subject ],
            html:     html
          }
        end

        def html
          content = Hashie::Mash.new({ notification: notification })
          Slim::Template.new(notification.email_template).render(content)
        end
    end
  end
end
