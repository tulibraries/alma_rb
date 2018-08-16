require "spec_helper"

describe Alma::Loan do
  before(:all) do
    Alma.configure
  end

  describe "#fetch" do
    it 'is responded to' do
      expect(described_class).to respond_to :fetch
    end

    it 'returns a LoanSet object' do
      expect(described_class.fetch(123)).to be_a Alma::LoanSet
    end

    it 'expands renewableby default' do
      described_class.fetch(123)
      expect(WebMock).to have_requested(:get, /.*\.exlibrisgroup\.com/)
      .with(query: hash_including({expand: "renewable"}))
    end

    it 'passes extra arguments as query params' do
      described_class.fetch(123, limit: 25, order_by: "due_date")
      expect(WebMock).to have_requested(:get, /.*\.exlibrisgroup\.com/)
      .with(query: hash_including({limit: "25", order_by: "due_date"}))
    end
  end

  describe '.renewable?' do

      it "returns false when renew json attribute is null" do
        loan = described_class.new JSON.parse("{\"loan_id\": \"6\",\"renew\": null}")
        expect(loan.renewable?).to be false
      end

      it "returns false when renew json attribute is missing" do
        loan = described_class.new JSON.parse("{\"loan_id\": \"6\"}")
        expect(loan.renewable?).to be false
      end

      it "returns true when renew json attribute is set" do
        loan = described_class.new JSON.parse("{\"loan_id\": \"6\",\"renew\": true}")
        expect(loan.renewable?).to be true
      end
  end
end
