# frozen_string_literal: true

module Alma
  class BibHolding
    extend Alma::ApiDefaults
    extend Forwardable

    def self.find(mms_id:, holding_id:)
      url = "#{bibs_base_path}/#{mms_id}/holdings/#{holding_id}"
      response = Net.get(url, headers:, timeout:)
      new(response)
    end

    attr_reader :holding
    def_delegators :holding, :[], :[]=, :has_key?, :keys, :to_json, :each

    def initialize(holding)
      @holding = holding
    end

    def holding_id
      holding["holding_id"]
    end
  end
end
