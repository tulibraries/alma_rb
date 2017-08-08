require "spec_helper"

describe Alma::RenewalResponse do
  before(:all) do
    Alma.configure
  end

  let(:renewal) { Alma::User.renew_loan({loan_id: 'RENEWED_ID', user_id: 'ID1234'})}

  context 'successful renewal' do
    describe '#renewed?' do
      it 'returns true' do
        expect(renewal.renewed?).to be true
      end
    end

    describe '#due_date' do
      it 'returns a timestamp of the new due date' do
        expect(renewal.due_date).to eql '2014-06-23T14:00:00Z'
      end
    end

    describe '#item_title' do
      it 'rturns the title of the renewed object' do
        expect(renewal.item_title).to eql 'History'
      end
    end


    describe '#error_message' do
      it 'is empty' do
        expect(renewal.error_message).to be_nil
      end
    end

  end



end
