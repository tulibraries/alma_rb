require 'spec_helper'

describe Alma::LoanSet do
  before(:all) do
    Alma.configure
  end

  let(:loans) { Alma::Loan.fetch(123) }

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

    it 'maps over the expected number of  records' do
      expect(loans.map(&:renewable?).size).to eql 100
    end
  end

  describe 'all' do
    it 'responds to all' do
      expect(loans).to respond_to :all
    end

    it 'should make three calls to the api' do
      # OUr fixture object has 145 records
      loans.all.map(&:renewable?)
      expect(WebMock).to have_requested(:get, /.*\/users\/.*\/loans.*/).times(3)
    end

    it "loops over multiple pages of results" do
      expect(loans.all.map(&:renewable?).size).to eql 145
    end

    it 'has Alma::Loan object for eac item' do
      expect(loans.all.first).to be_a Alma::Loan
    end
  end




end
