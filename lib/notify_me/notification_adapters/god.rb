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

      def subject
        "[priority: %{priority}] [category: %{category}] %{title}" % { title: title, category: category, priority: priority }
      end

      def email_template
        './lib/notify_me/templates/god/email.html.slim'
      end

      private

        attr_reader :payload
    end
  end
end

