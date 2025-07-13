# frozen_string_literal: true

require 'net/http'
require 'timeout'
require 'nokogiri'
require 'kansai_train_info/errors'
require 'kansai_train_info/configuration'
require 'kansai_train_info/http_client'
require 'kansai_train_info/parser'
require 'kansai_train_info/route'
require 'kansai_train_info/status_formatter'

# rubocop:disable Metrics/ModuleLength
module KansaiTrainInfo
  # rubocop:disable Metrics/ClassLength
  class << self
    # Legacy constants for backward compatibility
    LINES = {
      大阪環状線: [4, 2, 263],
      近鉄京都線: [6, 5, 288],
      阪急京都線: [8, 2, 306],
      御堂筋線: [10, 3, 321],
      烏丸線: [34, 2, 318],
      東西線: [34, 3, 319]
    }.freeze

    DEFAULT_TIMEOUT = 10
    MAX_RETRIES = 3

    # 指定された路線の運行情報を取得する
    #
    # @param route_array [Array<String>] 取得したい路線名の配列
    # @param url [Boolean] 詳細URLを含めるかどうか（デフォルト: false）
    # @return [String, nil] 運行情報のメッセージ。正常運転の場合はnil
    # @raise [InvalidRouteError] 無効な路線名が指定された場合
    #
    # @example 単一路線の情報を取得
    #   KansaiTrainInfo.get(['大阪環状線'])
    #
    # @example 複数路線でURLを含める
    #   KansaiTrainInfo.get(['大阪環状線', '御堂筋線'], url: true)
    #
    # rubocop:disable Metrics/PerceivedComplexity
    def get(route_array, url: false)
      if route_array.empty?
        puts '利用可能な路線を入力してください'
        return nil
      end

      messages = []

      route_array.each do |route_name|
        route = route_registry.find(route_name)
        raise InvalidRouteError, "Invalid route: #{route_name}" unless route

        begin
          status = fetch_route_status(route)
          description = status && status != '平常運転' ? fetch_description(route.detail_url) : nil

          formatter = StatusFormatter.new(route_name, status)
          formatted_message = formatter.format(
            include_url: url,
            detail_url: route.detail_url,
            description: description
          )

          messages << formatted_message if formatted_message
        rescue NetworkError => e
          messages << "#{route_name}: ネットワークエラー - #{e.message}"
        rescue ParseError => e
          messages << "#{route_name}: データ解析エラー - #{e.message}"
        end
      end

      return nil if messages.empty?

      messages.compact.join(', ')
    end
    # rubocop:enable Metrics/PerceivedComplexity

    # 利用可能な路線を表示する
    #
    # @return [void]
    #
    # @example
    #   KansaiTrainInfo.help
    #   # => 利用可能な路線：
    #   # => 大阪環状線、近鉄京都線、阪急京都線, 御堂筋線, 烏丸線, 東西線
    def help
      help_message = "利用可能な路線：\n#{route_registry.names.join('、')}"
      puts help_message
    end

    private

    def route_registry
      @route_registry ||= RouteRegistry.new
    end

    def http_client
      @http_client ||= HttpClient.new
    end

    def fetch_route_status(route)
      url = "#{KansaiTrainInfo.configuration.base_url}/traininfo/area/6/"
      html = http_client.get(url)
      parser = Parser.new(html)
      parser.extract_status(route.status_xpath)
    end

    def fetch_description(detail_url)
      html = http_client.get(detail_url)
      parser = Parser.new(html)
      parser.extract_detail('//*[@id="mdServiceStatus"]/dl/dd/p')
    rescue NetworkError => e
      "詳細情報取得エラー: #{e.message}"
    rescue StandardError => e
      "詳細情報解析エラー: #{e.message}"
    end

    # Legacy method for backward compatibility
    def description(detail_url)
      html = http_client.get(detail_url)
      parser = Parser.new(html)
      result = parser.extract_detail('//*[@id="mdServiceStatus"]/dl/dd/p')
      result || '詳細情報を取得できませんでした'
    rescue StandardError
      '詳細情報を取得できませんでした'
    end

    # Legacy method for backward compatibility
    def message(route, state, url, detail_url)
      return "#{route}は運行情報がありません" if state.nil?

      # Remove status indicators without modifying the original string
      clean_state = state.gsub('[○]', '').gsub('[!]', '')
      puts "#{route}は#{clean_state}です" if clean_state == '平常運転'
      message = case clean_state
                when '運転状況'
                  "#{route}は#{clean_state}に変更があります。"
                when '列車遅延'
                  "#{route}は#{clean_state}があります。"
                when '運転見合わせ'
                  "#{route}は#{clean_state}しています。"
                end
      return "#{route}は#{clean_state}です" if message.nil?

      desc = description(detail_url)
      show_message = "#{message} #{desc}"
      url ? show_message + detail_url : show_message
    end

    # Legacy method for backward compatibility
    # rubocop:disable Metrics/AbcSize
    def fetch_url(url, retries = 0)
      uri = URI.parse(url)
      raise NetworkError, "Invalid URL: #{url}" unless uri.is_a?(URI::HTTP)

      Timeout.timeout(KansaiTrainInfo.configuration.timeout) do
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request_path = uri.path.empty? ? '/' : uri.path
          request = Net::HTTP::Get.new(request_path)
          request['User-Agent'] = KansaiTrainInfo.configuration.user_agent
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
      raise TimeoutError, "Request timeout after #{KansaiTrainInfo.configuration.timeout} seconds"
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
      unless retries < KansaiTrainInfo.configuration.max_retries
        raise NetworkError, "Connection failed after #{KansaiTrainInfo.configuration.max_retries} retries: #{e.message}"
      end

      Kernel.sleep(KansaiTrainInfo.configuration.retry_delays[retries])
      fetch_url(url, retries + 1)
    rescue StandardError => e
      raise NetworkError, "Network error: #{e.message}"
    end
    # rubocop:enable Metrics/AbcSize

    # Legacy method for backward compatibility
    def kansai_doc
      url = "#{KansaiTrainInfo.configuration.base_url}/traininfo/area/6/"
      html = fetch_url(url)
      Nokogiri::HTML.parse(html, nil, 'utf-8')
    rescue StandardError => e
      raise ParseError, "HTMLの解析に失敗しました: #{e.message}"
    end
  end
  # rubocop:enable Metrics/ClassLength
end
# rubocop:enable Metrics/ModuleLength
