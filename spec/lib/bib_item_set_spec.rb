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

    describe '#filter_techserv_unassigned_and_intref' do
      it 'filters specific locaation codes' do
      expect(bib_item_set.filter_techserv_unassigned_and_intref.size).to eq 3
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
  end
end
