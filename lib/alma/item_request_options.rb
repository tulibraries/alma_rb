module Alma
  class ItemRequestOptions
    extend Forwardable

    attr_accessor :request_options, :raw_response
    def_delegators :raw_response, :response, :request

    REQUEST_OPTIONS_PERMITTED_ARGS = [:user_id]

    def initialize(response)
      @raw_response = response
      @request_options = JSON.parse(response.body)["request_option"]
    end

    def self.get(mms_id, holding_id=nil, item_pid=nil, options={})
      url = "#{bibs_base_path}/#{mms_id}/holdings/#{holding_id}/items/#{item_pid}/request-options"
      options.select! {|k,_|  REQUEST_OPTIONS_PERMITTED_ARGS.include? k }
      response = HTTParty.get(url, headers: headers, query: options)
      new(response)
    end

    def hold_allowed?
      !request_options.select {|option| option["type"]["value"] == "HOLD" }.empty?
    end

    def digitization_allowed?
      !request_options.select {|option| option["type"]["value"] == "DIGITIZATION" }.empty?
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
