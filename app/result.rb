# encoding: UTF-8

module NotifyMe
  class Result

    attr_reader :code, :messages

    def initialize code, messages=[]
      @code = code
      @messages = [ *messages ]
    end
  end
end
