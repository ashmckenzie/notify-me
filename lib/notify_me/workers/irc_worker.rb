require 'sidekiq'
require 'cinch'

module NotifyMe
  module Workers
    class IrcWorker

      include Sidekiq::Worker

      QUEUE_NAME = :high
      sidekiq_options :queue => QUEUE_NAME

      def perform opts
        if irc_daemon.connected?
          opts['nicknames'].each do |nickname|
            irc_daemon.private_message(nickname, message(opts))
          end
        end
      end

      private

        def irc_daemon
          NotifyMe::Clients::Irc.irc_daemon
        end

        def message opts
          "Host: %s, Time: %s, Title: %s, Message: %s" % [ opts['host'], opts['time'], opts['title'], opts['message'] ]
        end
    end
  end
end
