require 'nokogiri'
require 'open-uri'


  url = 'https://transit.yahoo.co.jp/traininfo/area/6/'

  charset = nil

  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  # doc.xpath('//div[@class="labelSmall"]').each do |node|
  #   p node.xpath('h3').text
  # end

  status_xpath = "//*[@id='mdAreaMajorLine']/div[4]/table/tr[3]/td[1]"
  p doc.xpath(status_xpath).first.text
