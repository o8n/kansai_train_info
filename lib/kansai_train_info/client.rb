# frozen_string_literal: true

require 'net/http'
require 'nokogiri'
require 'timeout'
require 'kansai_train_info/errors'

module KansaiTrainInfo
  class << self
    LINES = {
      大阪環状線: [4, 2, 263],
      近鉄京都線: [6, 5, 288],
      阪急京都線: [8, 2, 306],
      御堂筋線: [10, 3, 321],
      烏丸線: [34, 2, 318],
      東西線: [34, 3, 319]
    }.freeze

    # rubocop:disable Layout/LineLength
    def get(route_array, url: false)
      messages = []

      route_array.each do |route|
        line = LINES[route.to_sym]
        raise InvalidRouteError, "Invalid route: #{route}" unless line

        status_xpath = "//*[@id='mdAreaMajorLine']/div[#{LINES[route.to_sym][0]}]/table/tr[#{LINES[route.to_sym][1]}]/td[2]"
        detail_url = "https://transit.yahoo.co.jp/traininfo/detail/#{LINES[route.to_sym][2]}/0/"
        begin
          state = kansai_doc.xpath(status_xpath).first&.text
          messages << message(route, state, url, detail_url)
        rescue NetworkError => e
          messages << "#{route}: ネットワークエラー - #{e.message}"
        rescue ParseError => e
          messages << "#{route}: データ解析エラー - #{e.message}"
        end
      end
      if messages.empty?
        puts '利用可能な路線を入力してください'
      else
        messages.join(', ')
      end
    end
    # rubocop:enable Layout/LineLength

    def kansai_doc
      url = 'https://transit.yahoo.co.jp/traininfo/area/6/'
      html = fetch_url(url)
      Nokogiri::HTML.parse(html, nil, 'utf-8')
    rescue StandardError => e
      raise ParseError, "HTMLの解析に失敗しました: #{e.message}"
    end

    def description(detail_url)
      detail_html = fetch_url(detail_url)
      detail_doc = Nokogiri::HTML.parse(detail_html, nil, 'utf-8')
      element = detail_doc.xpath('//*[@id="mdServiceStatus"]/dl/dd/p').first
      element&.text || '詳細情報を取得できませんでした'
    rescue NetworkError => e
      "詳細情報取得エラー: #{e.message}"
    rescue StandardError => e
      "詳細情報解析エラー: #{e.message}"
    end

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

      show_message = "#{message} #{description(detail_url)}"
      url ? show_message + detail_url : show_message
    end

    def help
      help_message = "利用可能な路線：\n大阪環状線、近鉄京都線、阪急京都線, 御堂筋線, 烏丸線, 東西線"
      puts help_message
    end

    DEFAULT_TIMEOUT = 10
    MAX_RETRIES = 3

    private

    def fetch_url(url_string, retries: 0)
      uri = URI.parse(url_string)
      Timeout.timeout(DEFAULT_TIMEOUT) do
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new(uri)
          request['User-Agent'] = "kansai_train_info/#{KansaiTrainInfo::VERSION}"
          response = http.request(request)

          case response
          when Net::HTTPSuccess
            # Create a mutable copy before force_encoding
            response.body.dup.force_encoding('UTF-8')
          else
            raise NetworkError, "HTTP Error: #{response.code} #{response.message}"
          end
        end
      end
    rescue Timeout::Error
      raise TimeoutError, "Request timeout after #{DEFAULT_TIMEOUT} seconds"
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
      raise NetworkError, "Connection failed after #{MAX_RETRIES} retries: #{e.message}" unless retries < MAX_RETRIES

      sleep(2**retries)
      fetch_url(url_string, retries: retries + 1)
    rescue StandardError => e
      raise NetworkError, "Network error: #{e.message}"
    end
  end
end
