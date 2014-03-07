require 'cinch'
require 'singleton'

module NotifyMe
  module Daemons
    class Irc

      include Singleton

      attr_reader   :bot
      attr_accessor :state

      def self.bot() instance.bot; end
      def self.connected?() instance.connected?; end
      def self.connect_async!() instance.connect_async!; end
      def self.connect!() instance.connect!; end

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

        self.state = 'connecting'
        previous_self = self

        self.bot = Cinch::Bot.new do
          configure do |c|
            c.server    = Config.app.services.irc.server
            c.nick      = Config.app.services.irc.nickname
            c.password  = Config.app.services.irc.password
          end

          on :connect do |m|
            Config.app.services.irc.owners.each do |nickname|
              m.bot.Target(nickname).msg('I am alive!')
            end

            previous_self.state = 'connected'
          end
        end

        bot.start
      end

      private

        attr_writer :bot
    end
  end
end
