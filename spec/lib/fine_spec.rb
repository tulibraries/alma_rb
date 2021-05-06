# frozen_string_literal: true

require "spec_helper"

describe Alma::Fine do
  before(:all) do
    Alma.configure
  end

  describe "#fetch_all_for" do
    it "is responded to" do
      expect(described_class).to respond_to :where_user
    end

    it "returns a ResultSet object" do
      expect(described_class.where_user(123)).to be_a Alma::ResultSet
    end


    it "passes extra arguments as query params" do
      described_class.where_user(123, status: "ACTIVE")
      expect(WebMock).to have_requested(:get, /.*\.exlibrisgroup\.com/)
      .with(query: hash_including({ status: "ACTIVE" }))
    end
  end
end
