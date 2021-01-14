require 'spec_helper'

RSpec.describe Alma::BibHolding do
  before(:all) do
    Alma.configure {}
  end
  describe ".find" do
    it "fetches and returns holding data" do
      holding = described_class.find(mms_id: "991227850000541", holding_id: "2282456310006421")
      expect(holding.holding_id).to eq "2282456310006421"
    end
  end
end
