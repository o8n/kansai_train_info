# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KansaiTrainInfo::CLI do
  let(:cli) { described_class.new }

  describe '#get' do
    before do
      allow(KansaiTrainInfo).to receive(:get).and_return('大阪環状線は平常運転です')
    end

    it 'calls KansaiTrainInfo.get with routes' do
      expect(KansaiTrainInfo).to receive(:get).with(['大阪環状線'])
      expect { cli.get('大阪環状線') }.to output("大阪環状線は平常運転です\n").to_stdout
    end

    it 'handles multiple routes' do
      allow(KansaiTrainInfo).to receive(:get).and_return('大阪環状線は平常運転です, 御堂筋線は平常運転です')
      expect(KansaiTrainInfo).to receive(:get).with(%w[大阪環状線 御堂筋線])
      expect { cli.get('大阪環状線', '御堂筋線') }.to output("大阪環状線は平常運転です, 御堂筋線は平常運転です\n").to_stdout
    end

    it 'does not output when result is nil' do
      allow(KansaiTrainInfo).to receive(:get).and_return(nil)
      expect { cli.get('大阪環状線') }.not_to output.to_stdout
    end
  end

  describe '#help' do
    it 'calls KansaiTrainInfo.help' do
      expect(KansaiTrainInfo).to receive(:help)
      cli.help
    end
  end
end
