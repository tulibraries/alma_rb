module Alma
  class RequestOptions
    class ResponseError < Alma::StandardError
    end

    extend Forwardable

    attr_accessor :request_options, :raw_response
    def_delegators :raw_response, :response, :request

    REQUEST_OPTIONS_PERMITTED_ARGS = [:user_id]

    def initialize(response)
      @raw_response = response
      validate(response)
      @request_options = response.parsed_response["request_option"]
    end


    def self.get(mms_id, options={})
      url = "#{bibs_base_path}/#{mms_id}/request-options"
      options.select! {|k,_|  REQUEST_OPTIONS_PERMITTED_ARGS.include? k }
      response = HTTParty.get(url, headers: headers, query: options)
      new(response)
    end

    def loggable
      { uri: @raw_response&.request&.uri.to_s
      }.select { |k, v| !(v.nil? || v.empty?) }
    end

    def validate(response)
      if response.code != 200
        raise ResponseError.new("Could not get request options.", loggable.merge(response.parsed_response))
      end
    end

    def hold_allowed?
      !request_options.nil? &&
        !request_options.select {|option| option["type"]["value"] == "HOLD" }.empty?
    end

    def digitization_allowed?
      !request_options.nil? &&
        !request_options.select {|option| option["type"]["value"] == "DIGITIZATION" }.empty?
    end

    def booking_allowed?
      !request_options.nil? &&
        !request_options.select {|option| option["type"]["value"] == "BOOKING" }.empty?
    end

    def resource_sharing_broker_allowed?
      !request_options.nil? &&
        !request_options.select {|option| option["type"]["value"] == "RS_BROKER" }.empty?
    end

    def ez_borrow_link
      broker = request_options.select {|option| option["type"]["value"] == "RS_BROKER" }
      broker.collect { |opt| opt["request_url"] }.first
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
