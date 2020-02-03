require 'nokogiri'
require 'open-uri'

module KansaiTrainInfo
  # def self.kansai_doc
  url = 'https://transit.yahoo.co.jp/traininfo/area/6/'
  charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
  doc = Nokogiri::HTML.parse(html, nil, charset)
  p doc.title
  doc.xpath('//div[@class="labelSmall"]').each do |node|
    p node.xpath('h3').text
  end

  doc.xpath('//div[@class="elmTbLstLine"]/table/tbody/tr').each do |node|
    p node.xpath('th').text
  end
  # end

  # def description
  #   charset = nil
  #   detail_html = URI.parse(detail_url).open do |f|
  #     charset = f.charset
  #     f.read
  #   end

  #   detail_doc = Nokogiri::HTML.parse(detail_html, nil, charset)
  #   detail_doc.xpath('//div[@class="elmTblLstLine"]')
  # end
end
