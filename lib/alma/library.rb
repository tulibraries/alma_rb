# frozen_string_literal: true

module Alma
  class Library < AlmaRecord
    extend Alma::ApiDefaults

    def self.all(args: {})
      response = HTTParty.get("#{configuration_base_path}/libraries", query: args, headers:, timeout:)
      if response.code == 200
        LibrarySet.new(response)
      else
        raise StandardError, get_body_from(response)
      end
    end

    def self.find(library_code:, args: {})
      response = HTTParty.get("#{configuration_base_path}/libraries/#{library_code}", query: args, headers:, timeout:)
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
