module Alma
  class FineSet < Alma::Enumerable
    attr_reader :response

    def_delegators :response, :[], :fetch

    def key
      'fee'
    end

    def sum
      fetch('total_sum', 0)
    end
    alias :total_sum :sum

    def currency
      fetch('currency', nil)
    end

    def total_record_count
      fetch('total_record_count', 0)
    end

    alias :total_records :total_record_count
  end
end
