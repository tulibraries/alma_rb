require "spec_helper"

describe 'Configuring Alma' do

  context 'when no attributes are set in the passed block' do

    before(:all) do
      Alma.configure {}
    end

    it 'uses default values' do
      expect(Alma.configuration.apikey).to eql 'TEST_API_KEY'
    end

    after(:all) do
      Alma.configuration = nil
    end
  end

  context 'when attributes are set in the passed block' do
    before(:all) do
      Alma.configure do |config|
        config.apikey =  'SOME_OTHER_API_KEY'
      end
    end

    it 'default value for that attribute is overridden' do
      expect(Alma.configuration.apikey).to eql 'SOME_OTHER_API_KEY'
    end

    it 'still sets the default value for attributes not overriden' do
      expect(Alma.configuration.region).to eql  'https://api-na.hosted.exlibrisgroup.com'
    end

    it 'sets a default timeout value' do
      expect(Alma.configuration.timeout).to eql 5
    end


    after(:all) do
      Alma.configuration = nil
    end
  end


end
