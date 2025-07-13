# frozen_string_literal: true

require 'nokogiri'

module KansaiTrainInfo
  class Parser
    attr_reader :document

    def initialize(html)
      @document = Nokogiri::HTML.parse(html, nil, 'utf-8')
    rescue StandardError => e
      raise ParseError, "HTMLの解析に失敗しました: #{e.message}"
    end

    def extract_status(xpath)
      @document.xpath(xpath).first&.text
    end

    def extract_detail(xpath)
      element = @document.xpath(xpath).first
      element&.text || '詳細情報を取得できませんでした'
    end
  end
end
