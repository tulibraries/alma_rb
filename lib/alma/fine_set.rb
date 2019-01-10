# frozen_string_literal: true

module Alma
  class FineSet < ResultSet
    class ResponseError < Alma::StandardError
    end

    attr_reader :results, :raw_response
    def_delegators :results, :empty?

    def initialize(raw_response)
      @raw_response = raw_response
      @response = raw_response.parsed_response
      validate(raw_response)
      @results = @response.fetch(key, [])
        .map { |item| single_record_class.new(item) }
    end

    def loggable
      { uri: @raw_response&.request&.uri.to_s
      }.select { |k, v| !(v.nil? || v.empty?) }
    end

    def validate(response)
      if response.code != 200
        message = "Could not find fines."
        log = loggable.merge(response.parsed_response)
        raise ResponseError.new(message, log)
      end
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
