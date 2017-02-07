module Alma
  class FineSet < ResultSet

    def top_level_key
      'fees'
    end

    def response_records_key
      'fee'
    end

    def sum
      @response[top_level_key].fetch('total_sum', 0)
    end

    def currency
      @response[top_level_key].fetch('currency', nil)
    end

  end
end