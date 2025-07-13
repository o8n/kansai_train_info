# frozen_string_literal: true

require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'timeout'

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

    # rubocop:disable Metrics/AbcSize, Layout/LineLength
    def get(route_array, url: false)
      messages = []

      route_array.each do |route|
        line = LINES[route.to_sym]
        raise KeyError, "Invalid route: #{route}" unless line

        status_xpath = "//*[@id='mdAreaMajorLine']/div[#{LINES[route.to_sym][0]}]/table/tr[#{LINES[route.to_sym][1]}]/td[2]"
        detail_url = "https://transit.yahoo.co.jp/traininfo/detail/#{LINES[route.to_sym][2]}/0/"
        state = kansai_doc.xpath(status_xpath).first&.text
        messages << message(route, state, url, detail_url)
      end
      if messages.empty?
        puts '利用可能な路線を入力してください'
      else
        messages.join(', ')
      end
    end
    # rubocop:enable Metrics/AbcSize, Layout/LineLength

    def kansai_doc
      url = 'https://transit.yahoo.co.jp/traininfo/area/6/'
      html = fetch_url(url)
      Nokogiri::HTML.parse(html, nil, 'utf-8')
    end

    def description(detail_url)
      detail_html = fetch_url(detail_url)
      detail_doc = Nokogiri::HTML.parse(detail_html, nil, 'utf-8')
      detail_doc.xpath('//*[@id="mdServiceStatus"]/dl/dd/p').first.text
    end

    def message(route, state, url, detail_url)
      return "#{route}は運行情報がありません" if state.nil?

      state&.slice!('[○]')
      state&.slice!('[!]')
      puts "#{route}は#{state}です" if state == '平常運転'
      message = case state
                when '運転状況'
                  "#{route}は#{state}に変更があります。"
                when '列車遅延'
                  "#{route}は#{state}があります。"
                when '運転見合わせ'
                  "#{route}は#{state}しています。"
                end
      show_message = "#{message} #{description(detail_url)}"
      url ? show_message + detail_url : show_message
    end

    def help
      help_message = "利用可能な路線：\n大阪環状線、近鉄京都線、阪急京都線, 御堂筋線, 烏丸線, 東西線"
      puts help_message
    end

    private

    def fetch_url(url_string)
      uri = URI.parse(url_string)
      Timeout.timeout(10) do
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new(uri)
          request['User-Agent'] = "kansai_train_info/#{KansaiTrainInfo::VERSION}"
          response = http.request(request)

          case response
          when Net::HTTPSuccess
            response.body.force_encoding('UTF-8')
          else
            raise "HTTP Error: #{response.code} #{response.message}"
          end
        end
      end
    rescue Timeout::Error
      raise 'Request timeout'
    rescue StandardError => e
      raise "Network error: #{e.message}"
    end
  end
end
