# frozen_string_literal: true

require "spec_helper"
require "webmock/rspec"

describe Alma::BibItem do

  before(:all) do
    Alma.configure {}
  end

  describe "class method find" do
    let(:mms_id) { "991004101219703811" }
    let(:args) { { holding_id: "9987654321", user_id: "test_id" } }

    let(:mms_only) { described_class.find(mms_id) }
    let(:with_options) { described_class.find(mms_id, args) }
    let(:with_invalid_options) { described_class.find(mms_id, args = { bad: "option" }) }

    describe "can accept paramaters" do
      it "of a lone mms_id" do
        expect { mms_only }.not_to raise_error
      end

      it "of an mms_id and an args Hash" do
        expect { with_options }.not_to raise_error
      end
    end

    describe ".find_one" do
      let(:mms_id) { "99117110763506421" }
      let(:holding_id) { "22195173890006421" }
      let(:item_pid) { "23195173880006421" }

      it "finds one specified item" do
        output = described_class.find_one(mms_id:, holding_id:, item_pid:)

        expect(a_request(:get, /.*bibs\/99117110763506421\/holdings\/22195173890006421\/items\/23195173880006421/))
          .to have_been_made
        expect(output.library_name).to eq "Firestone Library"
      end
    end

    describe ".find_by_barcode" do
      it "searches by barcode and resolves it" do
        output = described_class.find_by_barcode("32101108168939")

        expect(a_request(:get, /.*items\/23195173880006421.*/)).to have_been_made
        expect(output.library_name).to eq "Firestone Library"
      end
    end

    it "uses ALL as the default holdings id if a holdings id is not passed" do
      mms_only
      expect(a_request(:get, /.*holdings\/ALL.*/)).to have_been_made
    end

    it "passes optional args as request queries" do
      with_options
      expect(a_request(:get, /.*/).with(query: { user_id: "test_id" })).to have_been_made
    end

    it "filters invalid optional args" do
      with_invalid_options
      expect(a_request(:get, /.*/).with(query: { bad: "option" })).not_to have_been_made
    end
  end

  describe ".scan" do
    it "hits the endpoint and returns the item" do
      options = { op: "scan", library: "recap", circ_desk: "DEFAULT_CIRC_DESK", done: "true" }
      item = described_class.scan(mms_id: 9968643943506421, holding_id: 22258767470006421, item_pid: 23258767460006421, options:)

      expect(a_request(:post, /.*bibs\/9968643943506421\/holdings\/22258767470006421\/items\/23258767460006421/)).to have_been_made
      expect(item.library_name).to eq "ReCAP"
    end

    context "when required parameters are missing" do
      it "returns an error" do
        stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/.*\/holdings\/.*\/items\/.*/).
          to_return(status: 400,
                    headers: { "Content-Type" => "application/json" },
                    body: File.open(SPEC_ROOT + "/fixtures/scan_missing_params.json"))

        options = { op: "scan" }
        item = described_class.scan(mms_id: 9968643943506421, holding_id: 22258767470006421, item_pid: 23258767460006421, options:)

        expect(a_request(:post, /.*bibs\/9968643943506421\/holdings\/22258767470006421\/items\/23258767460006421/)).to have_been_made
        expect(item["errorsExist"]).to be true
      end
    end
  end

  describe "instance methods" do
    let (:normal_location) {
      {
        "bib_data" => { "mms_id" => "991004101219703811" },
        "holding_data" => {
          "call_number" => "PR4167.J2 1962",
          "in_temp_location" => false,
          "temp_call_number" => "",

        },
        "item_data" => {
          "library" => { "value" => "MAIN", "desc" => "Paley Library" },
          "location" => { "value" => "stacks", "desc" => "Main Stacks" },
          "base_status" => { "value" => "1", "desc" => "Item in place" },
          "description" => "a description",
          "public_note" => "a public note",
          "physical_material_type" => { "value" => "BOOK", "desc" => "Book" }
        }
      }
    }
    let (:temp_location) {
      {
        "holding_data" => {
          "call_number" => "PR4167.J2 1962",
          "in_temp_location" => true,
          "temp_library" => { "value" => "AMBLER", "desc" => "Ambler Library" },
          "temp_location" => { "value" => "flacks", "desc" => "Ambler Stacks" },
          "temp_call_number" => "TEMP CALL NUMBER",
        }
      }
    }
    let (:item) { described_class.new(normal_location) }
    let (:temp_item) { described_class.new(temp_location) }

    describe "in its normal location" do
      it "responds with expected library" do
        expect(item.library).to eql "MAIN"
      end

      it "responds with expected library name" do
        expect(item.library_name).to eql "Paley Library"
      end

      it "responds with expected location" do
        expect(item.location).to eql "stacks"
      end

      it "responds with expected location name" do
        expect(item.location_name).to eql "Main Stacks"
      end

      it "responds with expected call number" do
        expect(item.call_number).to eql "PR4167.J2 1962"
      end

      it "is in place" do
        expect(item.in_place?).to be true
      end

      it "has a public note" do
        expect(item.public_note).to eql "a public note"
      end

      it "has a description" do
        expect(item.description).to eql "a description"
      end

      it "has a physical_material_type" do
        expect(item.physical_material_type["value"]).to eql "BOOK"
      end
    end

    describe "in a temp_location" do
      it "responds with expected temporary library" do
        expect(temp_item.library).to eql "AMBLER"
      end

      it "responds with expected temporary library name" do
        expect(temp_item.library_name).to eql "Ambler Library"
      end

      it "responds with expected temporary  location" do
        expect(temp_item.location).to eql "flacks"
      end

      it "responds with expected temporary location name" do
        expect(temp_item.location_name).to eql "Ambler Stacks"
      end

      it "responds with expected temporary call number" do
        expect(temp_item.call_number).to eql "TEMP CALL NUMBER"

      end
    end

    describe "#missing_or_lost?" do
      it "correctly identifies missing items" do
        missing = { "item_data" => { "process_type" => { "value" => "MISSING" } } }
        expect(described_class.new(missing).missing_or_lost?).to be true
      end
    end
  end
end
