# require 'dcell'
require 'singleton'

module NotifyMe
  module Clients
    class Irc

      include Singleton

      # def self.irc_daemon() instance.irc_daemon; end

      # def irc_daemon
      #   @irc_daemon ||= DCell::Node['irc_daemon'][:irc_daemon]
      # end
    end
  end
end
