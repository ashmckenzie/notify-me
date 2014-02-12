# encoding: UTF-8

require 'sinatra/base'
require 'sinatra/reloader'
require 'stethoscope'

require 'better_errors' if ENV['RACK_ENV'] == 'development'

module NotifyMe
  class WebApp < Sinatra::Base

    configure :development do
      require 'pry'

      use BetterErrors::Middleware
      register Sinatra::Reloader

      LIBRARIES.each { |f| also_reload(f) }
    end

    configure :production do
      before do
        halt 401, 'Access denied' unless Config.app.api_keys.include?(params[:api_key])
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

      start_time = Time.now.to_i

      title   = params[:title]
      message = params[:message]

      if (title && message)
        status = enqueue_jobs(title, message) ? 'OK' : 'NOTOK'
      else
        status = 'INVALID'
      end

      {
        status: status,
        took:   Time.now.to_i - start_time
      }.to_json
    end

    private

      def enqueue_jobs title, message
        #sms_opts = { to: '+61417365255', body: message }
        #Workers::SmsWorker.perform_async(sms_opts)

        push_opts = { message: message, title: title }
        Workers::PushWorker.perform_async(push_opts)

        email_opts = {
          to:         'ash@greenworm.com.au',
          from:       'ash@greenworm.com.au',
          from_email: 'ash@greenworm.com.au',
          subject:    title,
          html:       message
        }
        Workers::EmailWorker.perform_async(email_opts)

        # Create an entry somewhere

      end
  end
end
