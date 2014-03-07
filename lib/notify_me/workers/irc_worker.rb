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
          message = "Title: %s, Message: %s" % [ opts['title'], opts['message'] ]

          opts['nicknames'].each do |nickname|
            NotifyMe::Daemons::Irc.bot.Target(nickname).msg(message)
          end
        end
      end
    end
  end
end
