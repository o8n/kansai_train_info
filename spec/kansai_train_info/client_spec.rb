# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KansaiTrainInfo do
  before do
    stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
      .to_return(body: File.read('spec/fixtures/area_6.html'), status: 200)

    stub_request(:get, %r{https://transit.yahoo.co.jp/traininfo/detail/.*})
      .to_return(body: File.read('spec/fixtures/detail.html'), status: 200)
  end

  describe '.get' do
    context 'with url option' do
      it 'includes detail URL in the response' do
        # Mock a state that triggers URL inclusion (not 平常運転)
        allow_any_instance_of(Nokogiri::HTML::Document).to receive(:xpath).and_return(
          double(first: double(text: '[!]列車遅延'))
        )

        result = KansaiTrainInfo.get(['大阪環状線'], url: true)
        expect(result).to include('https://transit.yahoo.co.jp/traininfo/detail/')
      end
    end

    context 'with empty route array' do
      it 'prints message and returns nil' do
        expect { KansaiTrainInfo.get([]) }.to output("利用可能な路線を入力してください\n").to_stdout
      end
    end

    context 'with route having different states' do
      let(:test_html) do
        <<~HTML
          <html>
            <body>
              <div id="mdAreaMajorLine">
                <div></div>
                <div></div>
                <div></div>
                <div>
                  <table>
                    <tr></tr>
                    <tr>
                      <td></td>
                      <td>[!]列車遅延</td>
                    </tr>
                  </table>
                </div>
              </div>
            </body>
          </html>
        HTML
      end

      it 'handles train delay state' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
          .to_return(body: test_html, status: 200)

        result = KansaiTrainInfo.get(['大阪環状線'])
        expect(result).to include('大阪環状線は列車遅延があります')
      end
    end

    context 'with suspended service state' do
      let(:suspended_html) do
        <<~HTML
          <html>
            <body>
              <div id="mdAreaMajorLine">
                <div></div>
                <div></div>
                <div></div>
                <div>
                  <table>
                    <tr></tr>
                    <tr>
                      <td></td>
                      <td>[!]運転見合わせ</td>
                    </tr>
                  </table>
                </div>
              </div>
            </body>
          </html>
        HTML
      end

      it 'handles suspended service state' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
          .to_return(body: suspended_html, status: 200)

        result = KansaiTrainInfo.get(['大阪環状線'])
        expect(result).to include('大阪環状線は運転見合わせしています')
      end
    end

    context 'with service status change' do
      let(:status_change_html) do
        <<~HTML
          <html>
            <body>
              <div id="mdAreaMajorLine">
                <div></div>
                <div></div>
                <div></div>
                <div>
                  <table>
                    <tr></tr>
                    <tr>
                      <td></td>
                      <td>[!]運転状況</td>
                    </tr>
                  </table>
                </div>
              </div>
            </body>
          </html>
        HTML
      end

      it 'handles service status change' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
          .to_return(body: status_change_html, status: 200)

        result = KansaiTrainInfo.get(['大阪環状線'])
        expect(result).to include('大阪環状線は運転状況に変更があります')
      end
    end

    context 'with normal operation' do
      let(:normal_html) do
        <<~HTML
          <html>
            <body>
              <div id="mdAreaMajorLine">
                <div></div>
                <div></div>
                <div></div>
                <div>
                  <table>
                    <tr></tr>
                    <tr>
                      <td></td>
                      <td>[○]平常運転</td>
                    </tr>
                  </table>
                </div>
              </div>
            </body>
          </html>
        HTML
      end

      it 'outputs normal operation message' do
        stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
          .to_return(body: normal_html, status: 200)

        expect { KansaiTrainInfo.get(['大阪環状線']) }.to output("大阪環状線は平常運転です\n").to_stdout
      end
    end
  end

  describe '.description' do
    context 'when detail element is not found' do
      let(:empty_detail_html) do
        <<~HTML
          <html>
            <body>
              <div id="mdServiceStatus">
                <dl>
                  <dd></dd>
                </dl>
              </div>
            </body>
          </html>
        HTML
      end

      it 'returns default message' do
        stub_request(:get, %r{https://transit.yahoo.co.jp/traininfo/detail/.*})
          .to_return(body: empty_detail_html, status: 200)

        # Access private method through send
        result = KansaiTrainInfo.send(:description, 'https://transit.yahoo.co.jp/traininfo/detail/263/0/')
        expect(result).to eq('詳細情報を取得できませんでした')
      end
    end
  end

  describe '.message' do
    it 'handles unknown state' do
      # Access private method through send
      result = KansaiTrainInfo.send(:message, '大阪環状線', '不明な状態', false, 'https://example.com')
      expect(result).to include('大阪環状線は不明な状態です')
    end
  end

  describe 'supported lines' do
    it 'handles all supported lines without error' do
      lines = %w[大阪環状線 近鉄京都線 阪急京都線 御堂筋線 烏丸線 東西線]
      lines.each do |line|
        expect { KansaiTrainInfo.get([line]) }.not_to raise_error
      end
    end
  end
end
