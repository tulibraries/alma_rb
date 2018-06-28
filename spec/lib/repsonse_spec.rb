require "spec_helper"

describe Alma::Response do
  before(:all) do
    Alma.configure
  end

  let(:response) {described_class.new(http_response)}

  describe 'errors method' do
    let(:http_response) { HTTParty.get("http://foo.com/error") }
    it 'returns an array of errors' do
      expect(response.errors).to be_an Array
    end

    it 'returns one error' do
      expect(response.errors.count).to eql 1
    end

    it 'returns an error with expected keys' do
      expect(response.errors.first.keys).to include("errorCode","errorMessage")
    end
  end

end
