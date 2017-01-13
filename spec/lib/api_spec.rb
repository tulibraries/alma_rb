require "spec_helper"

describe Alma::Api do

  before(:all) do
    @custom_region =  'https://api-eu.hosted.exlibrisgroup.com'
    Alma.configure { |c| c.region = @custom_region}
    @api = Object.new.extend(Alma::Api)
  end

  context "Instantiating a new object extending #{described_class}" do
    describe '#default_params' do

      let(:default_params) { @api.default_params }

      it 'exists' do
        expect(@api).to respond_to :default_params
      end

      it 'is a hash' do
        expect(default_params).to be_a Hash
      end

      it 'has a :query key' do
        expect(default_params).to have_key :query
      end

      it 'has a :apikey key in the Hash accessed by :query ' do
        expect(default_params[:query]).to have_key :apikey
      end
    end

    describe '#load_wadl' do
      let(:wadl_filename) { 'user.wadl'}
      let(:resources) { @api.load_wadl(wadl_filename)}

      it 'returns a Resource object' do
        expect(resources).to be_a EzWadl::Resource
      end

      it 'sets the custom path from configuration' do
        expect(resources.path).to eql @custom_region
      end

    end
  end
end