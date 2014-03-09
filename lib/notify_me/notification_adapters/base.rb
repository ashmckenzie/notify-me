require 'resolv'

module NotifyMe
  module NotificationAdapters
    class Base

      attr_reader :messages

      def initialize payload, request
        @payload = Hashie::Mash.new(payload)
        @request = request
        @messages = []
      end

      def to_s
        "<%s> %s" % [ self.class, payload.inspect ]
      end

      def match?
        true
      end

      def valid?
        messages << "Title is missing" if title.nil? || title.empty?
        messages << "Message is missing" if message.nil? || message.empty?
        messages.empty?
      end

      def title
        payload.title || message
      end

      def message
        payload.message
      end

      def host
        payload.host || request.ip
      end

      def reverse_host
        Resolv.getname(host)
      end

      def category
        payload.category || 'default'
      end

      def priority
        payload.priority || 'default'
      end

      def time
        payload.time || Time.now
      end

      def email_template
        './lib/notify_me/templates/base/email.html.slim'
      end

      def subject
        title
      end

      private

        attr_reader :payload, :request

    end
  end
end
