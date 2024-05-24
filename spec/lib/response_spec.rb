# frozen_string_literal: true

require "spec_helper"

describe Alma::Response do
  before(:all) do
    Alma.configure
  end

  describe "errors method" do
    let(:response) { described_class.new(http_response) }
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

  describe "successful response" do
    let(:response) { Alma::BibRequest.submit(
      mms_id: "request_success", user_id: "user_id", request_type: "HOLD", pickup_location_type: "LIBRARY", pickup_location_library: "MAIN"
    )}
    it "#request_id" do
      expect(response.request_id).to eq("12345")
    end
    it "#managed_by_library" do
      expect(response.managed_by_library).to eq("Ambler Campus Library")
    end
    it "#managed_by_library_code" do
      expect(response.managed_by_library_code).to eq("AMBLER")
    end
  end

end
