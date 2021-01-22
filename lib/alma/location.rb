module Alma
  class Location < AlmaRecord
    extend Alma::ApiDefaults

    def self.all(library_code:, args: {})
      response = HTTParty.get("#{configuration_base_path}/libraries/#{library_code}/locations", query: args, headers: headers, timeout: timeout)
      if response.code == 200
        LocationSet.new(response)
      else
        raise StandardError, get_body_from(response)
      end
    end

    def self.find(library_code:, location_code:, args: {})
      response = HTTParty.get("#{configuration_base_path}/libraries/#{library_code}/locations/#{location_code}", query: args, headers: headers, timeout: timeout)
      if response.code == 200
        AlmaRecord.new(response)
      else
        raise StandardError, get_body_from(response)
      end
    end

    def self.get_body_from(response)
      JSON.parse(response.body)
    end
  end
end
