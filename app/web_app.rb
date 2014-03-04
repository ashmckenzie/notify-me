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

    use Rack::ConditionalGet
    use Rack::ETag
    use Stethoscope

    set :views, File.join(ROOT_PATH, 'views')

    get '/' do
      erb :index
    end

    # TODO: deprecate this!!
    #
    post '/' do
      content_type :json
      params[:app_name] = 'default'
      process(params, request)
    end

    post '/:api_key/:app_name' do
      content_type :json
      process(params, request)
    end

    private

      def process params, request
        debug(params)

        start_time = Time.now.to_f
        result = process_payload(Hashie::Mash.new(params), request)
        status result.code

        { status: result.code, messages: result.messages, took: (Time.now.to_f - start_time).round(4) }.to_json
      end

      def process_payload params, request
        code = 200
        messages = []
        user = false

        begin
          user = User.lookup(params.api_key)
        rescue Errors::InvalidApiKeyError => e
          code = 401
          messages << "API key '#{params.api_key}' is invalid"
        end

        if user
          if app = user.app(params.app_name)

            payload = Hashie::Mash.new(params)
            notification = NotificationAdapterFactory.new(payload, request).fingerprint

            if (notification.valid?)
              if enqueue_jobs(notification, app)
                messages << "Enqueued jobs for API key '#{params.api_key}' and app '#{params.app_name}'"
              else
                code = 500
                messages << "Unable to enqueue jobs for API key '#{params.api_key}' and app '#{params.app_name}'"
              end
            else
              code = 466
              messages += notification.messages
            end

          else
            code = 401
            messages << "APP name '#{params.app_name}' is not valid for API key '#{params.api_key}'"
          end
        end

        Result.new(code, messages)
      end

      def enqueue_jobs notification, app
        jobs = []
        services = app.services.keys

        debug(notification)
        debug(app)

        add_job(jobs, Notifications::Sms.new(notification)) if services.include?('twilio')
        add_job(jobs, Notifications::Pushover.new(notification)) if services.include?('pushover')
        add_job(jobs, Notifications::Email.new(notification)) if services.include?('mandrill')
        jobs.join
      end

      def add_job jobs, job
        debug("Adding " + job.class.to_s)
        jobs << Thread.new { job.notify! }
      end

      def debug obj
        ap(obj) if development?
      end

      def development?
        ENV['RACK_ENV'] == 'development'
      end
  end
end
