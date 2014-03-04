# encoding: UTF-8

module NotifyMe
  class User

    attr_reader :api_key

    def initialize user
      @user = user
    end

    def self.lookup api_key
      user = NotifyMe::Config.app.users.detect { |u| u.api_key == api_key }
      raise Errors::InvalidApiKeyError, "Invalid API key '#{api_key}'" unless user
      self.new(user)
    end

    def name
      user.name
    end

    def app app_name
      user.apps[app_name]
    end

    private

      attr_reader :user

  end
end
