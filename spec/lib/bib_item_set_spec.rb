require "spec_helper"

describe Alma::BibItemSet do

  before(:all) do
    Alma.configure {}
  end

  let(:bib_item_set) { Alma::BibItem.find("foo") }

    it 'delegates #each to @items' do
      expect(bib_item_set.each).to be_a_kind_of Enumerable
    end

    it 'returns the expected number of items' do
      expect(bib_item_set.size).to eq 3
    end

    describe '#filter_missing_and_lost' do
      it 'filters the missing and lost items' do
      expect(bib_item_set.filter_missing_and_lost.size).to eq 2
      end
    end

    describe '#grouped_by_library' do
      let(:grouped) {bib_item_set.grouped_by_library}
      it 'returns the items grouped by library' do
        expect(grouped.keys).to match_array(["AMBLER","MAIN"])
      end

      it 'each library gourping has the expected items' do
        expect(grouped["MAIN"].size).to eq 2
        expect(grouped["AMBLER"].size).to eq 1
      end
    end

    describe 'all' do
      let(:bib_item_set) { Alma::BibItem.find("991026207509703811") }

      it 'responds to all' do
        expect(bib_item_set).to respond_to :all
      end

      it 'should make three calls to the api' do
        # Our fixture object has 290 records
        bib_item_set.all.map(&:item_data)
        expect(WebMock).to have_requested(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/991026207509703811\/holdings\/.*\/items/).times(4)
      end

      it "loops over multiple pages of results" do
        expect(bib_item_set.all.map(&:item_data).size).to eql 290
      end
    end

    describe "success?" do
      it "returns true when response code is 200" do
        expect(bib_item_set.success?).to be true
      end
    end
  end
