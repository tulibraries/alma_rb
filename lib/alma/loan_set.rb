# frozen_string_literal: true

module Alma
  class LoanSet < ResultSet
    class ResponseError < Alma::StandardError
    end

    alias :total_records :total_record_count


    attr_reader :results, :raw_response
    def_delegators :results, :empty?

    def initialize(raw_response, search_args = {})
      @raw_response = raw_response
      @response = raw_response.parsed_response
      @search_args = search_args
      validate(raw_response)
      @results = @response.fetch(key, []) || []
      @results.map! { |item| single_record_class.new(item) }
      # args passed to the search that returned this set
      # such as limit, expand, order_by, etc
    end

    def loggable
      { search_args: @search_args,
        uri: @raw_response&.request&.uri.to_s
      }.select { |k, v| !(v.nil? || v.empty?) }
    end

    def validate(response)
      if response.code != 200
        error = "Could not find loans info."
        log = loggable.merge(response.parsed_response)
        raise ResponseError.new(error, log)
      end
    end

    def all
      Enumerator.new do |yielder|
        offset = 0
        limit = 100
        loop do
          extra_args = @search_args.merge({ limit:, offset: })
          r = (offset == 0) ? self : single_record_class.where_user(user_id, extra_args)

          unless r.empty?
            r.map { |item| yielder << item }
            offset += 100
          end

          # TODO: r.count greater than "limit" doesn't make any sense unless the ALMA User/Loan API is broken.
          # We should remove this qualification in October once Alma fixes the bug they introduced in their
          # September release.
          # @see https://developers.exlibrisgroup.com/forums/topic/limit-and-offset-not-being-applied-to-retrieve-user-loans-api/
          if r.empty? || r.count < limit || r.count > limit
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
