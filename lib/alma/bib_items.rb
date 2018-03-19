module Alma
  class BibItems
    extend Forwardable

    attr_accessor :items
    def_delegators :items, :[], :[]=, :has_key?, :keys, :to_json

    attr_reader :raw_response
    def_delegators :raw_response, :response, :request

    def initialize(response)
      @raw_response = response
      @items = JSON.parse(response.body)
    end

    PERMITTED_ARGS  = [
      :limit, :offset, :expand, :user_id, :current_library,
      :current_location, :q, :order_by, :direction
    ]

    def self.find(mms_id, options={})
      holding_id = options.delete(:holding_id) || "ALL"
      options.select! {|k,_| PERMITTED_ARGS.include? k }
      url = "#{bibs_base_path}/#{mms_id}/holdings/#{holding_id}/items"
      response = HTTParty.get(url, headers: headers, query: options)
      new(response)
    end

    private

    def self.region
      Alma.configuration.region
    end

    def self.bibs_base_path
      "#{region}/almaws/v1/bibs"
    end

    def self.headers
      { "Authorization": "apikey #{apikey}",
       "Accept": "application/json",
       "Content-Type": "application/json" }
    end

    def self.apikey
      Alma.configuration.apikey
    end
  end
end
