# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'script.rb' do
  let(:script_path) { 'lib/kansai_train_info/script.rb' }

  it 'fetches and displays train status' do
    html_response = <<~HTML
      <html>
        <body>
          <div id="mdAreaMajorLine">
            <div></div>
            <div></div>
            <div></div>
            <div>
              <table>
                <tr></tr>
                <tr></tr>
                <tr>
                  <td>テスト路線</td>
                </tr>
              </table>
            </div>
          </div>
        </body>
      </html>
    HTML

    stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
      .to_return(body: html_response, status: 200)

    expect { load script_path }.to output("テスト路線\n").to_stdout
  end

  it 'handles HTTP errors' do
    stub_request(:get, 'https://transit.yahoo.co.jp/traininfo/area/6/')
      .to_return(status: 500, body: 'Internal Server Error')

    expect { load script_path }.to raise_error(RuntimeError, /HTTP Error: 500/)
  end
end
