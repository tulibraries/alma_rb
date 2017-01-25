require "spec_helper"


RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/multiple_bibs.xml').read,
                  :headers => { 'content-type' => ['application/xml;charset=UTF-8']})
  end
end

describe Alma::Bib do
  before(:all) do
    Alma.configure
  end

  describe "#get_bibs" do
    context 'with multiple result objects' do
      let(:bibs){described_class.send :get_bibs, %w{99106548420001021 99116529630001021}}

      it 'returns a BibSet object' do
        expect(bibs).to be_a Alma::BibSet
      end

      it 'has items in list' do
        expect(bibs.list).to_not be_empty
      end

      it 'does not have an error' do
        expect(bibs.has_error?).to be false
      end
    end
  end
end
