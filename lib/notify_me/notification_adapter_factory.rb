require 'hashie'

module NotifyMe
  class NotificationAdapterFactory

    def initialize payload, request
      @payload = Hashie::Mash.new(payload)
      @request = request
    end

    def fingerprint
      adapter = nil
      available_adapters.each do |adapter_class|
        adapter = adapter_class.new(payload, request)
        break if adapter.match?
      end
      adapter
    end

    private

      attr_reader :payload, :request

      def available_adapters
        [
          NotificationAdapters::God,
          NotificationAdapters::Base,
        ]
      end
  end
end
