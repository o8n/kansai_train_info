RSpec.describe KansaiTrainInfo do
  it "has a version number" do
    expect(KansaiTrainInfo::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(KansaiTrainInfo.greet).to eq("hello")
  end
end
