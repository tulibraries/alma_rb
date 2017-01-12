require "spec_helper"

describe Alma do
  it "has a version number" do
    expect(Alma::VERSION).not_to be nil
  end

  it 'has a constant wadl dir' do
    expect(Alma::WADL_DIR).not_to be nil
  end

end
