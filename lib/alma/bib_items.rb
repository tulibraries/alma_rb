module Alma
  class BibItems

    PERMITTED_ARGS  = %w{
      limit offset expand user_id current_library
      current_location q order_by direction }

    def self.find(mms_id, args={})
      holding_id = args.delete(:holding_id) || "ALL"
      args.select! {|k,_| PERMITTED_ARGS.include? k }
      url = "#{bibs_base_path}/#{mms_id}/holdings/#{holding_id}/items"
      HTTParty.get(url, headers: headers, query: args)
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
