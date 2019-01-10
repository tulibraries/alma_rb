module Alma
  class ItemRequestOptions < RequestOptions

    class ResponseError < Alma::StandardError
    end

    def self.get(mms_id, holding_id=nil, item_pid=nil, options={})
      url = "#{bibs_base_path}/#{mms_id}/holdings/#{holding_id}/items/#{item_pid}/request-options"
      options.select! {|k,_|  REQUEST_OPTIONS_PERMITTED_ARGS.include? k }
      response = HTTParty.get(url, headers: headers, query: options)
      new(response)
    end

    def validate(response)
      if response.code != 200
        message = "Could not get item request options."
        log = loggable.merge(response.parsed_response)
        raise ResponseError.new(message, log)
      end
    end
  end
end
