# frozen_string_literal: true

module KansaiTrainInfo
  class StatusFormatter
    STATUS_INDICATORS = {
      normal: '[○]',
      alert: '[!]'
    }.freeze

    STATUS_MESSAGES = {
      '運転状況' => ->(route) { "#{route}は運転状況に変更があります。" },
      '列車遅延' => ->(route) { "#{route}は列車遅延があります。" },
      '運転見合わせ' => ->(route) { "#{route}は運転見合わせしています。" }
    }.freeze

    def initialize(route_name, raw_status)
      @route_name = route_name
      @raw_status = raw_status
    end

    def format(include_url: false, detail_url: nil, description: nil)
      return "#{@route_name}は運行情報がありません" if @raw_status.nil?

      status = clean_status(@raw_status)

      if status == '平常運転'
        puts "#{@route_name}は#{status}です"
        return nil
      end

      message = build_message(status, description)
      include_url && detail_url ? "#{message}#{detail_url}" : message
    end

    private

    def clean_status(raw_status)
      STATUS_INDICATORS.values.reduce(raw_status) do |status, indicator|
        status.gsub(indicator, '')
      end
    end

    def build_message(status, description)
      base_message = STATUS_MESSAGES[status]&.call(@route_name) || "#{@route_name}は#{status}です"
      description ? "#{base_message} #{description}" : base_message
    end
  end
end
