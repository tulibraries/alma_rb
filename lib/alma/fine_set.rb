# frozen_string_literal: true

module Alma
  class FineSet < ResultSet


    attr_reader :results, :raw_response
    def_delegators :results, :empty?

    def initialize(raw_response)
      @raw_response = raw_response
      @response = JSON.parse(raw_response.body)
      @results = @response.fetch(key, [])
        .map { |item| single_record_class.new(item) }
    end

    def each(&block)
       @results.each(&block)
    end

    def success?
      raw_response.response.code.to_s == "200"
    end

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
