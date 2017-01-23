module Alma
  class LoanSet

    attr_reader :total_record_count, :list

    def initialize(ws_response)
      @ws_response = ws_response
      @total_record_count = ws_response.fetch(total_record_count, 0)
      @list ||= list_results
    end

    def response_records
      @ws_response['item_loans'].fetch('item_loan',[])
    end

    def list_results
      response_records.map do |loan|
        Alma::Loan.new(loan)
      end
    end

  end
end