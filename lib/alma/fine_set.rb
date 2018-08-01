# frozen_string_literal: true

module Alma
  class FineSet < ResultSet
    def key
      "fee"
    end

    def sum
      fetch("total_sum", 0)
    end

    alias :total_sum :sum

    def currency
      fetch("currency", nil)
    end
  end
end
