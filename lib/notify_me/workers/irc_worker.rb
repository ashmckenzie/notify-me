require 'sidekiq'
require 'cinch'

module NotifyMe
  module Workers
    class IrcWorker

      include Sidekiq::Worker

      QUEUE_NAME = :high
      sidekiq_options :queue => QUEUE_NAME

      def perform opts
        if NotifyMe::Daemons::Irc.connected?
          opts['nicknames'].each do |nickname|
            NotifyMe::Daemons::Irc.bot.Target(nickname).msg(message(opts))
          end
        end
      end

      private

        def message opts
          "Host: %s, Time: %s, Title: %s, Message: %s" % [ opts['host'], opts['time'], opts['title'], opts['message'] ]
        end
    end
  end
end
