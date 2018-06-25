require "spec_helper"
require "pry"

describe Alma::RequestOptions do

  before(:all) do
    Alma.configure {}
  end

  let(:mms_id) { "991004101219703811" }
  let(:args) { {user_id: "test_id"} }

  describe "class method get" do
    let(:mms_only) { described_class.get(mms_id) }
    let(:with_options) { described_class.get(mms_id, args) }
    let(:with_invalid_options) { described_class.get(mms_id, args={bad: "option"}) }

    describe "can accept paramaters" do
      it 'of a lone mms_id' do
        allow(described_class).to receive(:get).with(instance_of(String))
      end

      it 'of an mms_id and an args Hash' do
        allow(described_class)
          .to receive(:get).with(instance_of(String), instance_of(Hash))
      end

      it 'passes optional args as request queries' do
        expect(with_options.request.options[:query].keys).to include :user_id
      end
    end
  end

  describe "instance method hold_allowed?" do
    let(:ro) { described_class.get("991030169919703811")}
    let(:no_hold) { described_class.get("NOHOLD")}

    it 'returns true when a hold option is present' do
      expect(ro.hold_allowed?).to be true
    end

    it 'returns false when a hold option is not present' do
      expect(no_hold.hold_allowed?).to be false
    end
  end

  describe "instance method digitization_allowed?", :focus do
    let(:ro) { described_class.get("991030169919703811")}
    let(:no_hold) { described_class.get("NOHOLD")}

    it 'returns true when a digitization option is present' do
      expect(ro.hold_allowed?).to be true
    end

    it 'returns false when a digitization option is not present' do
      expect(no_hold.hold_allowed?).to be false
    end
  end
end
