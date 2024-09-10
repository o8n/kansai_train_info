# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

url = 'https://transit.yahoo.co.jp/traininfo/area/6/'

charset = nil

html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Logger::HTML.parse(html, nil, charset)

status_xpath = "//*[@id='mdAreaMajorLine']/div[4]/table/tr[3]/td[1]"

puts doc.xpath(status_xpath).first.text
