require "spec_helper"


describe Alma::Bib do
  before(:all) do
    Alma.configure
  end

  describe "#get_bibs" do
    context 'with multiple result objects' do
      let(:bibs){described_class.send :get_bibs, %w{991036881504003811 991036880906903811}}

      it 'returns a BibSet object' do
        expect(bibs).to be_a Alma::BibSet
      end

      it 'has items in each' do
        expect(bibs.each).to_not be_empty
      end

    end
  end
end
