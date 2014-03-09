require 'socket'

module NotifyMe
  class RandomPort

    FROM = 9000
    TO   = 9100

    def next_available
      begin
        port = random_port
        server = TCPServer.new('127.0.0.1', port)
        server.close
        port
      rescue Errno::EADDRINUSE
        retry
      end
    end

    def random_port
      rand(TO - FROM) + FROM
    end
  end
end
