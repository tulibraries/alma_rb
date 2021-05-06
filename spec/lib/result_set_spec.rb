# frozen_string_literal: true

require "spec_helper"

describe Alma::ResultSet do
  context "single result returned" do
    let(:set) { TestSet.new(Response.single_response) }


    describe "#total_record_count" do
      it "returns the expected amount" do
        expect(set.total_record_count).to eql 1
      end
    end

    describe "#list" do
      it "returns  an array" do
        expect(set.each).to be_an Array
      end

      it "has the expected number of items" do
        expect(set.each.size).to be 1
      end
    end


    context "delegated methods" do

      describe "#size" do

        it "has the expected size" do
          expect(set.size).to be 1
        end

      end

      describe "#each" do
        it "returns an enumerable" do
          expect(set.each).to be_a_kind_of Enumerable
        end

        it "returns objects of Expected class" do
          expect(set.each.first).to be_an Alma::AlmaRecord
        end

      end

      describe "#map" do
        it "#map returns an enumerable" do
          expect(set.map).to be_a_kind_of Enumerable
        end
      end
    end

  end
end


class TestSet < Alma::ResultSet
  def key
    "results"
  end
end

module Response
  def self.single_response
    {
        "results" =>
            [
            {
                "result_id" => "result1",
                "field1" => "value1",
                "field2" => "value2",
            }
            ],
        "total_record_count" => "1"
    }
  end
end
