# frozen_string_literal: true

require 'spec_helper'
require 'kansai_train_info/configuration'

RSpec.describe KansaiTrainInfo::Configuration do
  describe '#initialize' do
    it 'sets default values' do
      config = described_class.new
      
      expect(config.user_agent).to eq("kansai_train_info/#{KansaiTrainInfo::VERSION}")
      expect(config.timeout).to eq(10)
      expect(config.max_retries).to eq(3)
      expect(config.retry_delay).to eq(1)
      expect(config.base_url).to eq('https://transit.yahoo.co.jp')
    end
  end
  
  describe '#retry_delays' do
    it 'returns exponential backoff delays' do
      config = described_class.new
      config.retry_delay = 2
      
      expect(config.retry_delays).to eq([2, 4, 8])
    end
  end
end

RSpec.describe KansaiTrainInfo do
  describe '.configure' do
    after do
      KansaiTrainInfo.reset_configuration!
    end
    
    it 'allows configuration' do
      KansaiTrainInfo.configure do |config|
        config.timeout = 20
        config.max_retries = 5
        config.user_agent = 'custom-agent'
      end
      
      config = KansaiTrainInfo.configuration
      expect(config.timeout).to eq(20)
      expect(config.max_retries).to eq(5)
      expect(config.user_agent).to eq('custom-agent')
    end
  end
  
  describe '.reset_configuration!' do
    it 'resets configuration to defaults' do
      KansaiTrainInfo.configure do |config|
        config.timeout = 20
      end
      
      KansaiTrainInfo.reset_configuration!
      
      expect(KansaiTrainInfo.configuration.timeout).to eq(10)
    end
  end
end