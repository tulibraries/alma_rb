# frozen_string_literal: true

module Alma
  class LoanSet < ResultSet
    alias :total_records :total_record_count


    attr_reader :results, :raw_response
    def_delegators :results, :empty?

    def initialize(raw_response)
      @raw_response = raw_response
      @response = JSON.parse(raw_response.body)
      @results = @response.fetch(key, [])
        .map { |item| single_record_class.new(item) }
    end


    def all
      Enumerator.new do |yielder|
        offset = 0
        loop do
          r = (offset == 0) ? self : Alma::Loan.fetch(user_id, {limit: 100, offset: offset})
          unless r.empty?
            r.map { |item| yielder << item }
            offset += 100
          else
            raise StopIteration
          end
        end
      end
    end

    def each(&block)
       @results.each(&block)
    end

    def key
      "item_loan"
    end

    def single_record_class
      Alma::Loan
    end

    private
      def user_id
        @user_id ||= results.first.user_id
      end
  end
end
