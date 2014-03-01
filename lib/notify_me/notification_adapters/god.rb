module NotifyMe
  module NotificationAdapters
    class God < Base

      def title
        "God notification for %{host} at %{time}" % { host: host, time: time }
      end

      def match?
        !!(payload.message &&
          payload.time &&
          payload.host &&
          payload.has_key?(:priority) &&
          payload.has_key?(:category)
        )
      end

      private

        attr_reader :payload
    end
  end
end

