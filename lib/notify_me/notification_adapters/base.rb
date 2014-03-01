require 'hashie'

module NotifyMe
  module NotificationAdapters
    class Base

      def initialize payload, request
        @payload = Hashie::Mash.new(payload)
        @request = request
      end

      def match?
        true
      end

      def valid?
        !title.empty? && !message.empty?
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

      def category
        payload.category || 'default'
      end

      def priority
        payload.priority || 'default'
      end

      def time
        payload.time || Time.now
      end

      private

        attr_reader :payload, :request

    end
  end
end
