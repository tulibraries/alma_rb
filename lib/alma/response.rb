# frozen_string_literal: true

require "forwardable"

module Alma
  class Response
    class StandardError < Alma::StandardError
    end

    extend ::Forwardable

    attr_reader :raw_response
    def_delegators :raw_response, :body, :success?, :response, :request

    def initialize(response)
      @raw_response = response
      @response = response.parsed_response
      validate(response)
    end

    def loggable
      { uri: @raw_response&.request&.uri.to_s
      }.select { |k, v| !(v.nil? || v.empty?) }
    end

    def validate(response)
      if errors.first&.dig("errorCode") == "401136"
        message = "The requested item already exists."
        log = loggable.merge(response.parsed_response)

        raise Alma::BibRequest::ItemAlreadyExists.new(message, log)
      end

      if response.code != 200
        log = loggable.merge(response.parsed_response)
        raise StandardError.new("Invalid Response.", log)
      end
    end

    def request_id
      @response.fetch("request_id", "")
    end

    def managed_by_library
      @response.fetch("managed_by_library", "")
    end

    def managed_by_library_code
      @response.fetch("managed_by_library_code", "")
    end

    # Returns an array of errors
    def errors
      @response&.dig("errorList", "error") || []
    end
  end
end
