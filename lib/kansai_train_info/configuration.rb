# frozen_string_literal: true

module KansaiTrainInfo
  class Configuration
    attr_accessor :user_agent, :timeout, :max_retries, :retry_delay, :base_url

    def initialize
      @user_agent = "kansai_train_info/#{VERSION}"
      @timeout = 10
      @max_retries = 3
      @retry_delay = 1
      @base_url = 'https://transit.yahoo.co.jp'
    end

    def retry_delays
      (0...@max_retries).map { |i| @retry_delay * (2**i) }
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end