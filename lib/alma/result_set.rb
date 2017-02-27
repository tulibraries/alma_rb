module Alma
  class ResultSet
    extend Forwardable

		include Enumerable
    include Alma::Error

    def_delegators :list, :each, :size

    def initialize(ws_response)
      @response = ws_response
    end

    def total_record_count
      @response[top_level_key].fetch('total_record_count', 0).to_i
    end

    def list
      @list ||= list_results
    end


    def top_level_key
      raise NotImplementedError 'Subclasses of ResultSet Need to define the top level key'
    end

    def response_records_key
      raise NotImplementedError 'Subclasses of ResultSet Need to define the key for response records'
    end

    private
    def response_records
      @response[top_level_key].fetch(response_records_key,[])
    end

    # Subclasses Can override this to use a Custom Class for single record objects.
    def single_record_class
      Alma::AlmaRecord
    end

    def list_results
      #If there is only one record in the response, HTTParty returns as a hash, not
      # an array of hashes, so wrap in array to normalize.
      response_array = (response_records.is_a? Array) ? response_records : [response_records]
      response_array.map do |record|
        single_record_class.new(record)
      end
    end
  end
end
