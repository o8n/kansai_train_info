# typed: false
# spec/kansai_train_info_spec.rb
require 'kansai_train_info'
require 'webmock/rspec'
require 'pry'

RSpec.describe KansaiTrainInfo do
  before do
    stub_request(:get, "https://transit.yahoo.co.jp/traininfo/area/6/").
      to_return(body: File.read('spec/fixtures/area_6.html'), status: 200)

    stub_request(:get, %r{https://transit.yahoo.co.jp/traininfo/detail/.*}).
      to_return(body: File.read('spec/fixtures/detail.html'), status: 200)
  end

  describe '.get' do
    it 'returns operation status for given routes' do
      routes = %w[大阪環状線 近鉄京都線]
      result = KansaiTrainInfo.get(routes)
      expect(result).to be_an_instance_of(String)
    end

    it 'raises an error for invalid route' do
      routes = ['無効な路線']
      expect { KansaiTrainInfo.get(routes) }.to raise_error(KeyError)
    end
  end

  describe '.help' do
    it 'displays available routes' do
      expect { KansaiTrainInfo.help }.to output(/利用可能な路線/).to_stdout
    end
  end
end
