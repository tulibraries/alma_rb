module Alma
  class RequestSet < ResultSet


    def top_level_key
      'user_requests'
    end

    def response_records_key
      'user_request'
    end

  end
end