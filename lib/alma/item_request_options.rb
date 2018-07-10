module Alma
  class ItemRequestOptions < RequestOptions

    def self.get(mms_id, holding_id=nil, item_pid=nil, options={})
      url = "#{bibs_base_path}/#{mms_id}/holdings/#{holding_id}/items/#{item_pid}/request-options"
      options.select! {|k,_|  REQUEST_OPTIONS_PERMITTED_ARGS.include? k }
      response = HTTParty.get(url, headers: headers, query: options)
      new(response)
    end
  end
end
