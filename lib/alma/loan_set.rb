module Alma
  class LoanSet
    extend Forwardable
    include Enumerable
    include Alma::Enumerable

    attr_reader :response
    def_delegators :response, :[], :fetch

    def each
      @response.fetch(key, []).map{|item| Alma::Loan.new(item)}
    end

    def size
      each.count
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
