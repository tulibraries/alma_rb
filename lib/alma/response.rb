# frozen_string_literal: true

require "forwardable"

module Alma
  class Response
    extend ::Forwardable

    attr_reader :raw_response
    def_delegators :raw_response, :body, :success?, :response, :request

    def initialize(response)
      @raw_response = response
    end

    # Returns an array of errors
    def errors
      return [] if success?
      JSON.parse(body).dig("errorList", "error") || []
    end
  end
end
