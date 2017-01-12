require "spec_helper"

describe Alma::Api do

  before(:all) do
    Alma.configure {}
    @api = Alma::Api.new
  end

  context 'Instantiating a new object' do
    describe 'params attribute' do

      it 'exists' do
        expect(@api).to respond_to :params
      end

      it 'is a hash' do
        expect(@api.params).to be_a Hash
      end

      it 'has a :query key' do
        expect(@api.params).to have_key :query
      end

      it 'has a :apikey key in the Hash accessed by :query ' do
        expect(@api.params[:query]).to have_key :apikey
      end
    end
  end
end