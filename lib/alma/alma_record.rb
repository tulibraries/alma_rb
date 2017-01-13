module Alma
  class AlmaRecord

    attr_accessor :id

    def initialize(response_hash)
      @response = response_hash
      @id = response_hash['primary_id']
    end

    def method_missing(name)
      return response[name.to_s] if response.has_key?(name.to_s)
      super.method_missing name
    end

    def respond_to_missing?(name, include_private = false)
      response.has_key?(name.to_s) || super
    end

    def response
      @response
    end

  end
end