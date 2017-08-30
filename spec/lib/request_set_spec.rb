require 'spec_helper'

describe Alma::RequestSet do
  let(:response_hash) { JSON.load(open(File.join(SPEC_ROOT,'fixtures','requests.json'))) }
  let(:requests){described_class.new response_hash}

  it 'responds to total_records' do
    expect(requests).to respond_to :total_record_count
  end

  it 'lists the expected number of results' do
    expect(requests.total_record_count).to eql 1
  end

  context 'in extending enumerable it' do
    it 'responds to each' do
      expect(requests).to respond_to :each
    end

    it 'is a kind of enumerable' do
      expect(requests).to be_a_kind_of Enumerable
    end

    it 'has the expected number of results in the results array' do
      expect(requests.size).to eql 1
    end
  end


end
