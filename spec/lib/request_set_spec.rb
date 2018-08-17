require 'spec_helper'

describe Alma::RequestSet do
  let(:requests){Alma::UserRequest.where_user(123)}

  it 'responds to total_records' do
    expect(requests).to respond_to :total_record_count
  end

  it 'lists the expected number of results' do
    expect(requests.total_record_count).to eql 101
  end

  context 'in extending enumerable it' do
    it 'responds to each' do
      expect(requests).to respond_to :each
    end

    it 'is a kind of enumerable' do
      expect(requests).to be_a_kind_of Enumerable
    end

    it 'maps over the expected number of  records' do
      expect(requests.map(&:response).size).to eql 100
    end
  end

  describe 'all' do
    it 'responds to all' do
      expect(requests).to respond_to :all
    end

    it 'should make three calls to the api' do
      # OUr fixture object has 101 records
      requests.all.map(&:response)
      expect(WebMock).to have_requested(:get, /.*\/users\/.*\/requests.*/).times(3)
    end

    it "loops over multiple pages of results" do
      expect(requests.all.map(&:response).size).to eql 101
    end

    it 'has expect object for each item' do
      expect(requests.all.first).to be_a Alma::UserRequest
    end
  end

  describe "success?" do
    it "returns true when response code is 200" do
      expect(requests.success?).to be true
    end
  end

end
