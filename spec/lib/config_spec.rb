# frozen_string_literal: true

require "spec_helper"

describe "Configuring Alma" do
  before(:all) do
    Alma.configure {}
  end

  after(:all) do
    Alma.configuration = nil
  end

  context "when no attributes are set in the passed block" do
    it "uses default values" do

      expect(Alma.configuration.apikey).to eql "TEST_API_KEY"
      expect(Alma.configuration.enable_log_requests).to eql false
      expect(Alma.configuration.logger).to be_instance_of(Logger)
      expect(Alma.configuration.log_level).to eq(:info)
      expect(Alma.configuration.enable_debug_output).to eql false
      expect(Alma.configuration.debug_output_stream).to eq($stderr)
    end
  end

  context "when attributes are set in the passed block" do
    before(:all) do
      Alma.configure do |config|
        config.apikey =  "SOME_OTHER_API_KEY"
      end
    end

    it "default value for that attribute is overridden" do
      expect(Alma.configuration.apikey).to eql "SOME_OTHER_API_KEY"
    end

    it "still sets the default value for attributes not overriden" do
      expect(Alma.configuration.region).to eql  "https://api-na.hosted.exlibrisgroup.com"
    end

    it "sets a default timeout value" do
      expect(Alma.configuration.timeout).to eql 5
    end

    it "is possible to override the timeout configuration" do
      Alma.configure do |config|
        config.timeout = 10
      end
      expect(Alma.configuration.timeout).to eql 10
    end
  end

  context "when we enable logging via configuration" do
    before do
      Alma.configure do |config|
        config.enable_log_requests = true
      end
    end

    it "should eanble logging in Alma::Net class" do
      expect(Alma::Net.default_options[:logger]).to eq(Alma.configuration.logger)
      expect(Alma::Net.default_options[:log_level]).to eq(Alma.configuration.log_level)
      expect(Alma::Net.default_options[:log_format]).to eq(Alma.configuration.log_format)
    end
  end

  context "when we enable debugging via configuration" do
    before do
      Alma.configure do |config|
        config.enable_debug_output = true
      end
    end

    it "should set debugging options for Alma::Net class" do
      expect(Alma::Net.default_options[:debug_output]).to eq(Alma.configuration.debug_output_stream)
    end
  end

end
