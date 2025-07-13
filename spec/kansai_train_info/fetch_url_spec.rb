# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'KansaiTrainInfo#fetch_url' do
  describe 'retry mechanism' do
    let(:url) { 'https://transit.yahoo.co.jp/traininfo/area/6/' }

    context 'when connection succeeds after retries' do
      it 'retries up to MAX_RETRIES times' do
        # Stub request with explicit handling
        allow(Net::HTTP).to receive(:start).and_call_original

        # Mock the first two attempts to fail, third to succeed
        call_count = 0
        allow_any_instance_of(Net::HTTP).to receive(:request) do |_http, _request|
          call_count += 1
          raise Errno::ECONNREFUSED if call_count < 3

          response = Net::HTTPSuccess.new(nil, '200', 'OK')
          allow(response).to receive(:body).and_return('<html>success</html>')
          response
        end

        # Access private method through send
        result = KansaiTrainInfo.send(:fetch_url, url)
        expect(result).to eq('<html>success</html>')
        expect(call_count).to eq(3)
      end
    end

    context 'with exponential backoff' do
      it 'increases sleep time exponentially' do
        stub_request(:get, url).to_raise(Errno::EHOSTUNREACH)

        expect(KansaiTrainInfo).to receive(:sleep).with(1).ordered
        expect(KansaiTrainInfo).to receive(:sleep).with(2).ordered
        expect(KansaiTrainInfo).to receive(:sleep).with(4).ordered

        expect do
          KansaiTrainInfo.send(:fetch_url, url)
        end.to raise_error(KansaiTrainInfo::NetworkError, /Connection failed after 3 retries/)
      end
    end

    context 'when all retries fail' do
      it 'raises NetworkError after MAX_RETRIES attempts' do
        stub_request(:get, url).to_raise(Errno::ECONNREFUSED)

        expect do
          KansaiTrainInfo.send(:fetch_url, url)
        end.to raise_error(KansaiTrainInfo::NetworkError, /Connection failed after 3 retries/)
      end
    end

    context 'with different error types' do
      it 'handles generic StandardError' do
        stub_request(:get, url).to_raise(StandardError.new('Generic error'))

        expect do
          KansaiTrainInfo.send(:fetch_url, url)
        end.to raise_error(KansaiTrainInfo::NetworkError, /Network error: Generic error/)
      end

      it 'handles timeout with specific message' do
        allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)

        expect do
          KansaiTrainInfo.send(:fetch_url, url)
        end.to raise_error(KansaiTrainInfo::TimeoutError, 'Request timeout after 10 seconds')
      end
    end
  end
end
