# frozen_string_literal: true

require "spec_helper"

describe Alma::Response do
  before(:all) do
    Alma.configure
  end

  let(:response) { described_class.new(http_response) }

  describe "errors method" do
    let(:http_response) { HTTParty.get("http://foo.com/error") }
    it "raises a response error" do
      expect { response }.to raise_error(Alma::Response::StandardError)
    end

    context "loggable is enabled" do
      it "puts errors in error message as JSON" do
        Alma.configure { |c| c.enable_loggable = true }

        message =
          begin
            response
          rescue => e
            JSON.parse(e.message)
          end

        expect(message["error"]).to eq("Invalid Response.")
        expect(message["uri"]).to eq("http://foo.com/error")
        expect(message["errorList"]["error"]).to be_an(Array)
      end
    end
  end

end
