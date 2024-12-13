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
      expect(availability.keys).to eql %w{991023558879703811 991036880906903811
                                                  test-no-holding-code
                                                  test-single-empty-holding-code
                                                  test-single-nonempty-holding-code
                                                  test-three-nonempty-holding-codes
                                                  test-two-nonempty-and-two-empty-holding-codes }
    end

    it "has the expected value" do
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
          },
          "test-no-holding-code" =>
            { holdings: [{ "inventory_type" => "physical" }] },
          "test-single-empty-holding-code" =>
            { holdings: [{ "inventory_type" => "physical" }] },
          "test-single-nonempty-holding-code" =>
            { holdings: [{ "holding_info" => "One holding", "inventory_type" => "physical" }] },
          "test-three-nonempty-holding-codes" =>
            { holdings: [{ "holding_info" => "One holding Two holding Three holding", "inventory_type" => "physical" }] },
          "test-two-nonempty-and-two-empty-holding-codes" =>
            { holdings: [{ "holding_info" => "One holding Two holding", "inventory_type" => "physical" }] },
        }
      expect(availability).to eql expected
    end

    it "skips the empty holding info (code=t) subfield" do
      expect(availability["991023558879703811"][:holdings][0]["holding_info"]).to be_nil
      expect(availability["test-no-holding-code"][:holdings][0]["holding_info"]).to be_nil
      expect(availability["test-single-empty-holding-code"][:holdings][0]["holding_info"]).to be_nil
    end

    it "returns holdings info" do
      expect(availability["test-single-nonempty-holding-code"][:holdings][0]["holding_info"]).to eql "One holding"
    end

    it "returns multiple holdings info" do
      expect(availability["991036880906903811"][:holdings][0]["holding_info"]).to eql "holding-1 holding-2 holding-3"
      expect(availability["test-three-nonempty-holding-codes"][:holdings][0]["holding_info"]).to eql "One holding Two holding Three holding"
    end

    it "skips empty holding codes while returning the nonempty ones" do
      expect(availability["test-two-nonempty-and-two-empty-holding-codes"][:holdings][0]["holding_info"]).to eql "One holding Two holding"
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
