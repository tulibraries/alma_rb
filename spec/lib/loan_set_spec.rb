require 'spec_helper'

describe Alma::LoanSet do
  let(:response_hash) { JSON.load(open(File.join(SPEC_ROOT,'fixtures','loans.json'))) }
  let(:loans) { described_class.new response_hash }

  it 'responds to total_record_count' do
    expect(loans).to respond_to :total_record_count
  end

  context 'in extending enumerable it' do
    it 'responds to each' do
      expect(loans).to respond_to :each
    end

    it 'is a kind of enumerable' do
      expect(loans).to be_a_kind_of Enumerable
    end

    it 'has the expected number of results in the results array' do
      expect(loans.size).to eql 3
    end
  end


end
