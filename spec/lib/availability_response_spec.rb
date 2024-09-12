# frozen_string_literal: true

require "spec_helper"

describe Alma::AvailabilityResponse do

  before(:all) do
    Alma.configure
  end

  describe "availability attribute" do
    let(:availability) { Alma::Bib.get_availability(["991023558879703811", "991036880906903811"]).availability }

    it "returns a hash" do
      expect(availability).to be_a Hash
    end

    it "has the expected keys" do
      expect(availability.keys).to eql %w{991023558879703811 991036880906903811}
    end

    it "has the exepected value" do
    expected =
      { "991023558879703811" =>
       { holdings:
        [{
        "holding_id" => "22277782420003811",
        "institution" => "01TULI_INST",
        "library_code" => "MAIN",
        "location" => "Stacks",
        "call_number" => "NX511.N4 N513 2006",
        "availability" => "available",
        "total_items" => "2",
        "non_available_items" => "0",
        "location_code" => "stacks",
        "call_number_type" => "0",
        "priority" => "1",
        "library" => "Paley Library",
        "inventory_type" => "physical" },
         {
        "holding_id" => "22277782440003811",
        "institution" => "01TULI_INST",
        "library_code" => "AMBLER",
        "location" => "Stacks",
        "call_number" => "NX511.N4 N513 2006",
        "availability" => "available",
        "total_items" => "1",
        "non_available_items" => "0",
        "location_code" => "stacks",
        "call_number_type" => "0",
        "priority" => "2",
        "library" => "Ambler Campus Library",
        "inventory_type" => "physical" }] },
     "991036880906903811" =>
      { holdings:
        [{
        "holding_id" => "22413618700003811",
        "institution" => "01TULI_INST",
        "library_code" => "MAIN",
        "location" => "Stacks",
        "call_number" => "PN4775 .F45 2019",
        "availability" => "available",
        "total_items" => "1",
        "non_available_items" => "0",
        "location_code" => "stacks",
        "call_number_type" => "0",
        "priority" => "1",
        "library" => "Paley Library",
        "inventory_type" => "physical",
        "holding_info" => "holding-1 holding-2 holding-3" }]
        }
      }
    expect(availability).to eql expected

  end

    describe "availability hash members value" do
      it "has the expected keys" do
        expect(availability["991023558879703811"]).to have_key :holdings
      end
    end

    describe "holdings data in availability hash" do
      it "has the expected keys" do
        keys = %w{availability location call_number inventory_type}
        expect(availability["991023558879703811"][:holdings].first.keys).to include(*keys)
      end
    end
  end
end
