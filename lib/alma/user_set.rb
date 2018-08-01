# frozen_string_literal: true

module Alma
  class UserSet
    def top_level_key
      "users"
    end

    def response_records_key
      "user"
    end

    def single_record_class
      Alma::User
    end
  end
end
