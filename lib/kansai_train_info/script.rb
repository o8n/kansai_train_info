# frozen_string_literal: true

require 'nokogiri'
require 'net/http'
require 'timeout'

url = 'https://transit.yahoo.co.jp/traininfo/area/6/'

uri = URI.parse(url)
html = Timeout.timeout(10) do
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new(uri)
    response = http.request(request)

    case response
    when Net::HTTPSuccess
      # Create a mutable copy before force_encoding
      response.body.dup.force_encoding('UTF-8')
    else
      raise "HTTP Error: #{response.code} #{response.message}"
    end
  end
end

doc = Nokogiri::HTML.parse(html, nil, 'utf-8')

status_xpath = "//*[@id='mdAreaMajorLine']/div[4]/table/tr[3]/td[1]"

puts doc.xpath(status_xpath).first.text
