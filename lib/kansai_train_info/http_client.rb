# frozen_string_literal: true

require 'net/http'
require 'timeout'

module KansaiTrainInfo
  class HttpClient
    def initialize(config = KansaiTrainInfo.configuration)
      @config = config
    end

    # rubocop:disable Metrics/AbcSize
    def get(url, retries: 0)
      uri = URI.parse(url)

      Timeout.timeout(@config.timeout) do
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new(uri)
          request['User-Agent'] = @config.user_agent
          response = http.request(request)

          case response
          when Net::HTTPSuccess
            response.body.dup.force_encoding('UTF-8')
          else
            raise NetworkError, "HTTP Error: #{response.code} #{response.message}"
          end
        end
      end
    rescue Timeout::Error
      raise TimeoutError, "Request timeout after #{@config.timeout} seconds"
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
      unless retries < @config.max_retries
        raise NetworkError, "Connection failed after #{@config.max_retries} retries: #{e.message}"
      end

      sleep(@config.retry_delays[retries])
      get(url, retries: retries + 1)
    rescue StandardError => e
      raise NetworkError, "Network error: #{e.message}"
    end
    # rubocop:enable Metrics/AbcSize
  end
end
