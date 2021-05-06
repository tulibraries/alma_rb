# frozen_string_literal: true

module Alma
  class AlmaRecord
    def initialize(record)
      @raw_record = record
      post_initialize()
    end

    def method_missing(name)
      return response[name.to_s] if response.has_key?(name.to_s)
      super.method_missing name
    end

    def respond_to_missing?(name, include_private = false)
      response.has_key?(name.to_s) || super
    end

    def response
      @raw_record
    end

    def post_initialize
      # Subclasses can define this method to perform extra initialization
      # after the super class init.
    end
  end
end
