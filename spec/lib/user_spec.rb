require "spec_helper"


RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*\/.*/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/single_user.xml').read,
                  :headers => { 'content-type' => ['application/xml;charset=UTF-8']})
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*\/fees\/.*/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/fines.xml').read,
                  :headers => { 'content-type' => ['application/xml;charset=UTF-8']})


  end
end

describe Alma::User do
  before(:all) do
    Alma.configure
  end

  describe '#new' do
    let(:response_hash) {  {
        'primary_id'=>'testymc',
        'first_name'=>'Testy',
        'middle_name'=>nil,
        'last_name'=>'McTesterson',
        'full_name'=>'Testy McTesterson',
        'other_field' => {'nested' => 'value'}

    }}
    let(:user){described_class.new response_hash}

    it 'defines and id attribute' do
      expect(user.id).to eql 'testymc'
    end

    it 'responds to response hash keys as atributes' do
      expect(user).to respond_to :first_name
    end

    it 'returns the expected values of attributes' do
      expect(user.last_name).to eql 'McTesterson'
    end

    it 'responds to attributes with nil value' do
      expect(user.middle_name).to eql nil
    end

    it 'responds to loans' do
      expect(user).to respond_to :loans
    end

    it 'responds to fines' do
      expect(user).to respond_to :fines
    end

  end

  describe 'Static Methods' do

    describe "#{described_class}.find_by_id" do

      let(:user) {described_class.find_by_id({:user_id => "johns"})}

      it 'returns a User object' do
        expect(user).to be_a Alma::User
      end
    end

    describe "#{described_class}.fines" do
      let(:fines) {described_class.fines({:user_id => "johns"})}


      it 'responds to total_records' do
        expect(fines).to respond_to :total_results

      end
    end
  end
end
