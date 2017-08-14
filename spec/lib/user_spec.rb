require "spec_helper"

describe Alma::User do
  before(:all) do
    Alma.configure
  end

  describe '#new' do
    let(:response_hash) {  {
        'primary_id'  =>'testymc',
        'first_name'  =>'Testy',
        'middle_name' =>nil,
        'last_name'   =>'McTesterson',
        'full_name'   =>'Testy McTesterson',
        'other_field' => {'nested' => 'value'},
        'desc_field'  => {'desc' => "How is a rspec like writing a desc", 'value' => 'a value' }

    }}
    let(:user){described_class.new response_hash}

    it 'defines an id attribute' do
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

    it 'returns a hash for a field that is a hash' do
      expect(user.other_field).to be_a Hash
    end

    it 'allows values to be accessed via hash nested keys' do
      expect(user['desc_field']['desc']).to eql 'How is a rspec like writing a desc'
    end

    describe '#loans' do
      it 'is responded to' do
        expect(user).to respond_to :loans
      end

      it 'returns a LoanSet object' do
        expect(user.loans).to be_a Alma::LoanSet
      end


    end

    describe '#fines' do
      it 'is responded to' do
        expect(user).to respond_to :fines
      end

      it 'returns a FineSet object' do
        expect(user.fines).to be_a Alma::FineSet
      end
    end
    
    describe '#update' do
      it 'is responded to' do
        expect(user).to respond_to :update
      end
    end

    describe '#email' do
      it 'is responded to' do
        expect(user).to respond_to :email
      end
    end
    
    describe '#update_email!' do
      it 'is responded to' do
        expect(user).to respond_to :update_email!
      end
    end

    describe "#{described_class}.authenticate" do
      let(:auth_success) {described_class.authenticate({user_id: 'johns', password: 'right_password'}) }
      let(:auth_fail) {described_class.authenticate({user_id: 'johns', password: 'wrong_password'}) }

      context 'Successful authentication' do
        it 'returns true' do
          expect(auth_success).to be true
        end
      end

      context 'Unsuccessful authentication' do
        it 'returns false' do
          expect(auth_fail).to be false
        end
      end

    end
  end
end
