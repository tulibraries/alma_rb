require "spec_helper"

describe Alma::User do
  before(:all) do
    Alma.configure
  end

  describe '#find' do
    let(:user){Alma::User.find('johns')}

    it 'includes expand parameters by default' do
      user
      expect(WebMock).to have_requested(:get, /.*\/users.*/).
        with(query: hash_including({expand: "fees,requests,loans"}))
    end

    it 'allows extra parameters to be included' do
      Alma::User.find('johns', {expand: "fee,fi,fo,fum"})
      expect(WebMock).to have_requested(:get, /.*\/users.*/).
        with(query: hash_including({expand: "fee,fi,fo,fum"}))
    end



    it 'defines an id attribute' do
      expect(user.id).to eql 'johns'
    end

    it 'responds to response hash keys as atributes' do
      expect(user).to respond_to :first_name
    end

    it 'returns the expected values of attributes' do
      expect(user.last_name).to eql 'Smith'
    end

    it 'responds to attributes with empty value' do
      expect(user.middle_name).to eql ''
    end

    it 'returns a hash for a field that is a hash' do
      expect(user.contact_info).to be_a Hash
    end

    it 'allows values to be accessed via hash nested keys' do
      expect(user['preferred_language']['value']).to eql 'en'
    end

    describe '#total methods' do
      it 'returns the expected total if the element is present' do
        expect(user.total_loans).to eql "14"
      end

      it 'returns 0 if the element is missing' do
        expect(user.total_fines).to eql "0"
      end
    end


    describe '#loans' do
      it 'is responded to' do
        expect(user).to respond_to :loans
      end

      it 'returns a LoanSet object' do
        expect(user.loans).to be_a Alma::LoanSet
      end

      it 'expands renewableby default' do
        user.loans
        expect(WebMock).to have_requested(:get, /.*\.exlibrisgroup\.com/)
          .with(query: hash_including({expand: "renewable"}))
      end

      it 'passes extra arguments as query params' do
        user.loans(limit: 25)
        expect(WebMock).to have_requested(:get, /.*\.exlibrisgroup\.com/)
          .with(query: hash_including({limit: "25"}))
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

    describe '#save!' do
      it 'is responded to' do
        expect(user).to respond_to :save!
      end
    end

    describe '#email' do
      it 'is responded to' do
        expect(user).to respond_to :email
      end

      it 'returns the expected value' do
        expect(user.email).to eql ['johns@mylib.org', 'johns@myOTHERlib.org']
      end
    end

    describe '#preferred_email' do
      it 'is responded to' do
        expect(user).to respond_to :preferred_email
      end

      it 'returns the expected value' do
        expect(user.preferred_email).to eql 'johns@mylib.org'

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
