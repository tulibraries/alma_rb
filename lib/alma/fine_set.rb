module Alma
  class FineSet < ResultSet

    def top_level_key
      'fees'
    end

    def response_records_key
      'fee'
    end

    def sum
      @ws_response['fees'].fetch('total_sum', 0)
    end

    def currency
      @ws_response['fees'].fetch('total_sum', nil)
    end

  end
end