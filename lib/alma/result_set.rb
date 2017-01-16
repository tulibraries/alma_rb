module Alma
  class ResultSet

    def initialize(ws_response)
      @ws_response = ws_response
    end


    def total_record_count
      @ws_response[top_level_key].fetch('total_record_count', 0).to_i
    end

    def list
      @list ||= list_results
    end

    private
    def top_level_key
      raise NotImplementedError 'Subclasses of ResultSet Need to define the top level key'
    end

    def response_records_key
      raise NotImplementedError 'Subclasses of ResultSet Need to define the key for response records'
    end


    def response_records
      @ws_response[top_level_key].fetch(response_records_key,[])
    end

    def list_results
      #If there is only one record in the response, HTTParty returns as a hash, not
      # an array of hashes, so wrap in array to normalize.
      response_array = (total_record_count == 1) ? [response_records] : response_records

      response_array.map do |record|
        Alma::AlmaRecord.new(record)
      end
    end
  end
end