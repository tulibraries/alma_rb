# frozen_string_literal: true

module Alma
  class Fine < AlmaRecord
    extend Alma::ApiDefaults

    def self.where_user(user_id, args = {})
      response = Net.get("#{users_base_path}/#{user_id}/fees", query: args, headers:, timeout:)
      if response.code == 200
        Alma::FineSet.new(response)
      else
        raise StandardError, get_body_from(response)
      end
    end
  end
end
