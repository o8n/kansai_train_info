# spec/kansai_train_info_spec.rb
require 'kansai_train_info'
require 'webmock/rspec'
require 'pry'

RSpec.describe KansaiTrainInfo do
  before do
    stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
      .to_return(body: File.read('spec/fixtures/area_6.html'), status: 200)

    stub_request(:get, %r{https://transit.yahoo.co.jp/traininfo/detail/.*})
      .to_return(body: File.read('spec/fixtures/detail.html'), status: 200)
  end

  describe '.get' do
    it 'returns operation status for given routes' do
      routes = %w[大阪環状線 近鉄京都線]
      result = KansaiTrainInfo.get(routes)
      expect(result).to be_an_instance_of(String)
    end

    it 'raises an error for invalid route' do
      routes = ['無効な路線']
      expect { KansaiTrainInfo.get(routes) }.to raise_error(KansaiTrainInfo::InvalidRouteError)
    end
  end

  describe '.help' do
    it 'displays available routes' do
      expect { KansaiTrainInfo.help }.to output(/利用可能な路線/).to_stdout
    end
  end

  describe 'error handling' do
    context 'when network timeout occurs' do
      it 'handles timeout gracefully' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/').to_timeout
        routes = ['大阪環状線']
        result = KansaiTrainInfo.get(routes)
        expect(result).to include('データ解析エラー')
      end
    end

    context 'when connection refused' do
      it 'retries and handles connection error' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
          .to_raise(Errno::ECONNREFUSED).then
          .to_raise(Errno::ECONNREFUSED).then
          .to_raise(Errno::ECONNREFUSED).then
          .to_raise(Errno::ECONNREFUSED)

        routes = ['大阪環状線']
        result = KansaiTrainInfo.get(routes)
        expect(result).to include('データ解析エラー')
      end
    end

    context 'when HTTP error occurs' do
      it 'handles HTTP errors gracefully' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
          .to_return(status: 503, body: 'Service Unavailable')

        routes = ['大阪環状線']
        result = KansaiTrainInfo.get(routes)
        expect(result).to include('データ解析エラー')
      end
    end

    context 'when parse error occurs' do
      it 'handles invalid HTML gracefully' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
          .to_return(body: '<invalid>html</invalid>', status: 200)

        routes = ['大阪環状線']
        result = KansaiTrainInfo.get(routes)
        expect(result).to be_an_instance_of(String)
      end
    end
  end
end
