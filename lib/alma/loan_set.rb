module Alma
  class LoanSet
    extend Forwardable
    include Enumerable
    #include Alma::Error

    attr_reader :response
    def_delegators :list, :each, :size
    def_delegators :response, :[], :fetch

    def initialize(response_body_hash)
      @response = response_body_hash
    end

    def list
      @response[key].map{|item| Alma::Loan.new(item)}
    end

    def key
      'item_loan'
    end

    def total_record_count
      fetch('total_record_count', 0)
    end
    alias :total_records :total_record_count

  end
end
