# frozen_string_literal: true

module KansaiTrainInfo
  class Route
    attr_reader :name, :area_index, :row_index, :detail_id

    def initialize(name:, area_index:, row_index:, detail_id:)
      @name = name
      @area_index = area_index
      @row_index = row_index
      @detail_id = detail_id
    end

    def status_xpath
      "//*[@id='mdAreaMajorLine']/div[#{area_index}]/table/tr[#{row_index}]/td[2]"
    end

    def detail_url
      "#{KansaiTrainInfo.configuration.base_url}/traininfo/detail/#{detail_id}/0/"
    end

    def to_sym
      name.to_sym
    end
  end

  class RouteRegistry
    def initialize
      @routes = {}
      register_default_routes
    end

    def register(name, area_index:, row_index:, detail_id:)
      route = Route.new(
        name: name,
        area_index: area_index,
        row_index: row_index,
        detail_id: detail_id
      )
      @routes[name.to_sym] = route
    end

    def find(name)
      @routes[name.to_sym]
    end

    def all
      @routes.values
    end

    def names
      @routes.keys.map(&:to_s)
    end

    private

    def register_default_routes
      register('大阪環状線', area_index: 4, row_index: 2, detail_id: 263)
      register('近鉄京都線', area_index: 6, row_index: 5, detail_id: 288)
      register('阪急京都線', area_index: 8, row_index: 2, detail_id: 306)
      register('御堂筋線', area_index: 10, row_index: 3, detail_id: 321)
      register('烏丸線', area_index: 34, row_index: 2, detail_id: 318)
      register('東西線', area_index: 34, row_index: 3, detail_id: 319)
    end
  end

  class << self
    def route_registry
      @route_registry ||= RouteRegistry.new
    end
  end
end