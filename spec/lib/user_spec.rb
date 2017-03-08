require "spec_helper"

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
      let(:fines) {described_class.get_fines({:user_id => "johns"})}


      it 'responds to total_records' do
        expect(fines).to respond_to :total_record_count
      end

      it 'lists the expected number of results' do
        expect(fines.total_record_count).to eql 4
      end

      it 'has the expected number of results' do
        expect(fines.list.size).to eql 4
      end

      it 'responds to sum' do
        expect(fines).to respond_to :sum
      end

      it 'lists the expected summed total' do
        expect(fines.sum).to eql "415.0"
      end

    end

    describe "#{described_class}.requests" do
      let(:requests) {described_class.get_requests({:user_id => "johns"})}


      it 'responds to total_records' do
        expect(requests).to respond_to :total_record_count
      end

      it 'lists the expected number of results' do
        expect(requests.total_record_count).to eql 1
      end

      it 'responds to list' do
        expect(requests).to respond_to :list
      end

      it 'returns an array when list is called' do
        expect(requests.list).to be_an Array
      end

      it 'has the expected number of results' do
        expect(requests.list.size).to eql 1
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
