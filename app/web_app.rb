# encoding: UTF-8

require 'sinatra/base'
require 'sinatra/reloader'
require 'stethoscope'
require 'hashie'

require 'better_errors' if ENV['RACK_ENV'] == 'development'

module NotifyMe
  class WebApp < Sinatra::Base

    configure :development do
      require 'pry'
      require 'awesome_print'

      use BetterErrors::Middleware
      register Sinatra::Reloader

      LIBRARIES.each { |f| also_reload(f) }
    end

    configure :production do
      before do
        halt 401, 'Access denied' unless api_keys.include?(params[:api_key])
        @api_key = params[:api_key]
      end
    end

    use Rack::ConditionalGet
    use Rack::ETag
    use Stethoscope

    set :views, File.join(ROOT_PATH, 'views')

    get '/' do
      erb :index
    end

    post '/' do
      content_type :json

      start_time = Time.now.to_f
      status = process_payload(params, request)

      { status: status, took: (Time.now.to_f - start_time).round(4) }.to_json
    end

    private

      def api_keys
        @api_keys ||= NotifyMe::Config.app.users.map { |x| x.api_key }
      end

      def process_payload params, request
        payload = Hashie::Mash.new(params)
        notification = NotificationAdapterFactory.new(payload, request).fingerprint

        if (notification.valid?)
          enqueue_jobs(notification) ? 'OK' : 'NOTOK'
        else
          'INVALID'
        end
      end

      def enqueue_jobs notification
        [
          # Thread.new { Notifications::Sms.new(notification).notify! }
          Thread.new { Notifications::Pushover.new(notification).notify! },
          Thread.new { Notifications::Email.new(notification).notify! },
        ].join
      end
  end
end
