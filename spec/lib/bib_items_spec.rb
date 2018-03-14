require "spec_helper"
require "pry"

describe Alma::BibItems do

  before(:all) do
    Alma.configure {}
  end

  let(:mms_id) { "991004101219703811" }
  let(:options) { {holding_id: "9987654321"} }

  describe "class method find" do
    describe "can accept paramaters" do

      let(:mms_only) { described_class.find(mms_id) }
      let(:with_options) { described_class.find(mms_id, options) }

      it 'of a lone mms_id' do
        allow(described_class).to receive(:find).with(instance_of(String))
      end

      it 'of an optional options Hash' do
        allow(described_class)
          .to receive(:find).with(instance_of(String), instance_of(Hash))
      end
    end

    it 'uses ALL as the default holdings id if a holdings id is not passed' do
      response = described_class.find(mms_id)
      expect(response.request.uri.to_s).to include("holdings/ALL")
    end

    it 'returns an #{described_class} object'

  end




  it "fetches the data from the api endpoint" do
    mms_id = "991029347659703811"

    api_call = described_class.find(mms_id)

    expect(api_call.response.code).to eq "200"
  end
end
