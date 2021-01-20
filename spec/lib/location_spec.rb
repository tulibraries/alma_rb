require "spec_helper"

describe Alma::Location do
  before(:all) do
    Alma.configure
  end

  describe "#all" do
    it 'is responded to' do
      expect(described_class).to respond_to :all
    end

    it 'returns a LocationSet object' do
      result = described_class.all(library_code: 'main')
      expect(result).to be_a Alma::LocationSet
      expect(result.empty?).to be false
      expect(result[0].code).to eq 'offsite'
    end

    context 'when the server returns an error' do
      it 'raises an error' do
        expect { described_class.all(library_code: 'invalid', args: { format: 'error' }) }.to raise_error(StandardError, /errorList/)
      end
    end
  end

  describe "#find" do
    it 'is responded to' do
      expect(described_class).to respond_to :find
    end

    it 'returns an AlmaRecord object' do
      result = described_class.find(library_code: 'main', location_code: 'offsite')
      expect(result).to be_a Alma::AlmaRecord
      expect(result.code).to eq "offsite"
    end

    context 'when the server returns an error' do
      it 'raises an error' do
        expect { described_class.find(library_code: 'invalid', location_code: 'invalid', args: { format: 'error' }) }.to raise_error(StandardError, /errorList/)
      end
    end
  end
end
