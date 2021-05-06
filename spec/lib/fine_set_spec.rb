# frozen_string_literal: true

require "spec_helper"

describe Alma::FineSet do
  before(:all) do
    Alma.configure
  end

  let(:fines) { Alma::Fine.where_user(123) }

  it "returns the expected sum" do
    expect(fines.sum).to eql 415
  end

  it "also responds to total_sum for sum" do
    expect(fines).to respond_to :total_sum
  end

  it "lists the expected number of results" do
    expect(fines.total_record_count).to eql 4
  end

  it "responds to total_records" do
    expect(fines).to respond_to :total_records
  end

  context "in extending enumerable it" do
    it "responds to each" do
      expect(fines).to respond_to :each
    end

    it "is a kind of enumerable" do
      expect(fines).to be_a_kind_of Enumerable
    end

    it "has the expected number of results in the results array" do
      expect(fines.size).to eql 4
    end
  end

  describe "success?" do
    it "returns true when response code is 200" do
      expect(fines.success?).to be true
    end
  end

end
