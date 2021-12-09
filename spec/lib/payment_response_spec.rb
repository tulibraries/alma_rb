# frozen_string_literal: true

require "spec_helper"

describe Alma::PaymentResponse do
  before(:all) do
    Alma.configure
  end

  let(:balance) do
    Alma::User.send_payment(user_id: "foo")
  end

  context "successful payment" do
    describe "#paid?" do
      it "returns true" do
        expect(balance.paid?).to be true
      end
    end

    describe "#error_message" do
      it "is empty" do
        expect(balance.error_message).to be_nil
      end
    end

    describe "#payment_message" do
      it "provides paid statement" do
        expect(balance.payment_message).to eq("Your balance has been paid.")
      end
    end
  end
end
