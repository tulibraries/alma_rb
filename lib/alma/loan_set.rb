module Alma
  class LoanSet < ResultSet


    def top_level_key
      'item_loans'
    end

    def response_records_key
      'item_loan'
    end

    def single_record_class
      Alma::Loan
    end

  end
end
