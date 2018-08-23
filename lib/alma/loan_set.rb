# frozen_string_literal: true

module Alma
  class LoanSet < ResultSet
    alias :total_records :total_record_count


    attr_reader :results, :raw_response
    def_delegators :results, :empty?

    def initialize(raw_response, search_args={})
      @raw_response = raw_response
      @response = JSON.parse(raw_response.body)
      @results = @response.fetch(key, [])
        .map { |item| single_record_class.new(item) }
      # args passed to the search that returned this set
      # such as limit, expand, order_by, etc
      @search_args = search_args

    end


    def all
      Enumerator.new do |yielder|
        offset = 0
        loop do
          extra_args = @search_args.merge({limit: 100, offset: offset})
          r = (offset == 0) ? self : single_record_class.where_user(user_id, extra_args)
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

    def success?
      raw_response.response.code.to_s == "200"
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
