# frozen_string_literal: true

require "spec_helper"

describe Alma::Library do
  before(:all) do
    Alma.configure
  end

  describe "#all" do
    it "returns a LibrarySet object" do
      result = described_class.all
      expect(result).to be_a Alma::LibrarySet
      expect(result.empty?).to be false
      expect(result[0].id).to eq "123456789123456"
    end

    context "when the server returns an error" do
      it "raises an error" do
        expect { described_class.all(args: { format: "error" }) }.to raise_error(StandardError, /errorList/)
      end
    end
  end

  describe "#find" do
    it "returns an AlmaRecord object" do
      result = described_class.find(library_code: "main")
      expect(result).to be_a Alma::AlmaRecord
      expect(result.id).to eq "12900830000231"
    end

    context "when the server returns an error" do
      it "raises an error" do
        expect { described_class.find(library_code: "invalid", args: { format: "error" }) }.to raise_error(StandardError, /errorList/)
      end
    end
  end
end
