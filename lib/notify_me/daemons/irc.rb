# require 'dcell'
require 'cinch'

module NotifyMe
  module Daemons
    class Irc

      include Celluloid

      attr_reader   :bot
      attr_accessor :state

      def initialize
        self.state = 'disconnected'
      end

      def connect_async!
        return false unless state == 'disconnected'
        Thread.new { connect! }
      end

      def connected?
        self.state == 'connected'
      end

      def connect!
        return false unless state == 'disconnected'

        previous_self = self

        self.state = 'connecting'

        self.bot = Cinch::Bot.new do
          configure do |c|
            c.server    = Config.app.services.irc.server
            c.nick      = Config.app.services.irc.nickname
            c.password  = Config.app.services.irc.password
          end

          on :connect do |m|
            previous_self.state = 'connected'

            Config.app.services.irc.owners.each do |nickname|
              previous_self.private_message(nickname, 'I am alive!!!')
            end
          end
        end

        bot.start
      end

      def private_message nickname, message
        if nickname_online?(nickname)
          bot.Target(nickname).msg(message)
        end
      end

      def nickname_online? nickname
        true  # FIXME
        # if connected?
        #   bot.User(nickname).online
        # else
        #   false
        # end
      end

      private

        attr_writer :bot
    end
  end
end
