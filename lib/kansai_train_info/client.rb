# frozen_string_literal: true

require 'kansai_train_info/errors'
require 'kansai_train_info/configuration'
require 'kansai_train_info/http_client'
require 'kansai_train_info/parser'
require 'kansai_train_info/route'
require 'kansai_train_info/status_formatter'

module KansaiTrainInfo
  class << self
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
    # rubocop:disable Metrics/AbcSize
    def get(route_array, url: false)
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
      
      if messages.empty?
        puts '利用可能な路線を入力してください'
      else
        messages.compact.join(', ')
      end
    end
    # rubocop:enable Metrics/AbcSize

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

    def configuration
      @configuration ||= Configuration.new
    end

    def http_client
      @http_client ||= HttpClient.new
    end

    def fetch_route_status(route)
      url = "#{configuration.base_url}/traininfo/area/6/"
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
  end
end