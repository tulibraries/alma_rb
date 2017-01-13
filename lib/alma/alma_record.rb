module Alma
  class AlmaRecord

    attr_accessor :id

    def initialize(response_hash)
      @response = response_hash
      @id = response_hash['primary_id']
    end

    def method_missing(name)
      return response[name.to_s] if response.has_key?(name.to_s)
      response.each { |k,v| return v if k.to_s == name }
      super.method_missing name
    end

    def response
      @response
    end

  end
end