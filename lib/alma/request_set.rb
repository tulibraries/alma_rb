# frozen_string_literal: true

module Alma
  class RequestSet < ResultSet
    class ResponseError < Alma::StandardError
    end

    alias :total_records :total_record_count

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
        error = "Could not find requests."
        log = loggable.merge(response.parsed_response)
        raise ResponseError.new(error, log)
      end
    end

    def all
      Enumerator.new do |yielder|
        offset = 0
        loop do
          r = (offset == 0) ? self : single_record_class.where_user(user_id, {limit: 100, offset: offset})
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
      "user_request"
    end

    def single_record_class
      Alma::UserRequest
    end

    private
      def user_id
        @user_id ||= get_user_id_from_path(raw_response.request.uri.path)
      end

      def get_user_id_from_path(path)
        # Path in user api calls starts with "/almaws/v1/users/123/maybe_something/else"
        split_path = path.split("/")
        # the part immediately following the "users" is going to be the user_id
        user_id_index = split_path.index("users") + 1
        split_path[user_id_index]
      end
  end
end
