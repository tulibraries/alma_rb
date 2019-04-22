module Alma
  class UserRequest < AlmaRecord
    extend Alma::ApiDefaults

    def self.where_user(user_id, args={})
      # Default to upper limit
      args[:limit] ||= 100
      response = HTTParty.get(
        "#{users_base_path}/#{user_id}/requests",
        query: args,
        headers: headers,
        timeout: timeout
      )
      Alma::RequestSet.new(response)
    end
  end
end
