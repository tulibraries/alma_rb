# frozen_string_literal: true

module Alma
  class PaymentResponse
    def initialize(response)
      @raw_response = response
      @response = response.parsed_response
      @success  = response["total_sum"] == 0.0
    end

    def loggable
      { uri: @raw_response&.request&.uri.to_s
      }.select { |k, v| !(v.nil? || v.empty?) }
    end

    def paid?
      @success
    end

    def has_payment_error?
      !paid?
    end

    def payment_message
      if paid?
        "Your balance has been paid."
      else
        "There was a problem processing your payment. Please contact the library for assistance."
      end
    end

    def error_message
      @response unless paid?
    end
  end
end
