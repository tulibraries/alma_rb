# frozen_string_literal: true

module Alma
  class RequestSet < ResultSet
    alias :total_records :total_record_count

    def key
      "user_request"
    end
  end
end
