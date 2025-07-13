# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KansaiTrainInfo::Error do
  it 'is a StandardError' do
    expect(described_class).to be < StandardError
  end
end

RSpec.describe KansaiTrainInfo::NetworkError do
  it 'is a KansaiTrainInfo::Error' do
    expect(described_class).to be < KansaiTrainInfo::Error
  end

  it 'can be raised with a message' do
    expect { raise described_class, 'Network failed' }.to raise_error(described_class, 'Network failed')
  end
end

RSpec.describe KansaiTrainInfo::TimeoutError do
  it 'is a NetworkError' do
    expect(described_class).to be < KansaiTrainInfo::NetworkError
  end
end

RSpec.describe KansaiTrainInfo::ParseError do
  it 'is a KansaiTrainInfo::Error' do
    expect(described_class).to be < KansaiTrainInfo::Error
  end
end

RSpec.describe KansaiTrainInfo::InvalidRouteError do
  it 'is a KansaiTrainInfo::Error' do
    expect(described_class).to be < KansaiTrainInfo::Error
  end
end
