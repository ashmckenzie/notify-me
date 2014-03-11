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

      def host_and_reverse
        "%s (%s)" % [ reverse_host, host ]
      end

      # FIXME: this should be IP
      def host
        @host ||= payload.host || request.ip
      end

      # FIXME: this should be host
      def reverse_host
        @reverse_host ||= Resolv.getname(host)
      rescue Resolv::ResolvError => e
        'unknown'
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
