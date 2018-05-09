require "spec_helper"
require "pry"

describe Alma::BibItems do

  before(:all) do
    Alma.configure {}
  end

  let(:mms_id) { "991004101219703811" }
  let(:args) { {holding_id: "9987654321", user_id: "test_id"} }

  describe "class method find" do
    let(:mms_only) { described_class.find(mms_id) }
    let(:with_options) { described_class.find(mms_id, args) }
    let(:with_invalid_options) { described_class.find(mms_id, args={bad: "option"}) }

    describe "can accept paramaters" do
      it 'of a lone mms_id' do
        allow(described_class).to receive(:find).with(instance_of(String))
      end

      it 'of an mms_id and an args Hash' do
        allow(described_class)
          .to receive(:find).with(instance_of(String), instance_of(Hash))
      end
    end

    it 'uses ALL as the default holdings id if a holdings id is not passed' do
      expect(mms_only.request.uri.to_s).to include("holdings/ALL")
    end

    it 'passes optional args as request queries' do
      expect(with_options.request.options[:query].keys).to include :user_id
    end

    it 'filters invalid optional args' do
      expect(with_invalid_options.request.options[:query].keys).not_to include :bad
    end
  end

  describe "#{described_class} instance" do
    it "responds to items"
    it "it delegates hash access to items"
    it "responds to raw_response"
  end
end
