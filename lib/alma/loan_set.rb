# frozen_string_literal: true

module Alma
  class LoanSet < ResultSet
    alias :total_records :total_record_count

    def key
      "item_loan"
    end

    def single_record_class
      Alma::Loan
    end
  end
end
