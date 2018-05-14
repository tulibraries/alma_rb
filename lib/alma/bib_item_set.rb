module Alma
  class BibItemSet
    extend Forwardable

    attr_accessor :items
    def_delegators :items, :[], :[]=, :has_key?, :keys, :to_json

    attr_reader :raw_response, :total_record_count
    def_delegators :raw_response, :response, :request

    def initialize(response)
      @raw_response = response
      parsed = JSON.parse(response.body)
      @total_record_count = parsed["total_record_count"]
      @items = parsed["item"].map {|item| BibItem.new(item)}
    end

    def grouped_by_library
      group_by(&:library)
    end

    def filter_missing_and_lost
      items.reject(&:missing_or_lost?)
    end
  end
end
