require "spec_helper"
require "pry"

describe Alma::ItemRequestOptions do

  before(:all) do
    Alma.configure {}
  end

  let(:mms_id) { "991004101219703811" }
  let(:holding_id) { "22247693330003811" }
  let(:item_pid) { "23247693320003811" }
  let(:args) { {user_id: "test_id"} }

  describe "class method get" do
    let(:mms_only) { described_class.get(mms_id, holding_id, item_pid) }
    let(:with_options) { described_class.get(mms_id,holding_id, item_pid, args) }
    let(:with_invalid_options) { described_class.get(mms_id, holding_id, item_pid, args={bad: "option"}) }

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
    let(:item_ro) { described_class.get("991030169919703811", "22242987750003811", "23242987720003811")}
    let(:item_no_hold) { described_class.get("ITEMNOHOLD", 123, 456)}

    it 'returns true when a hold option is present' do
      expect(item_ro.hold_allowed?).to be true
    end

    it 'returns false when a hold option is not present' do
      expect(item_no_hold.hold_allowed?).to be false
    end
  end

  describe "instance method digitization_allowed?" do
    let(:item_ro) { described_class.get("991030169919703811", "22242987750003811", "23242987720003811")}
    let(:item_no_hold) { described_class.get("ITEMNOHOLD", 123, 456)}

    it 'returns true when a digitization option is present' do
      expect(item_ro.digitization_allowed?).to be true
    end

    it 'returns false when a digitization option is not present' do
      expect(item_no_hold.digitization_allowed?).to be false
    end
  end
end
