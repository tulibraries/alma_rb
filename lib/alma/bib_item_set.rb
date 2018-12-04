# frozen_string_literal: true

module Alma
  class BibItemSet < ResultSet
    attr_accessor :items
    attr_reader :raw_response, :total_record_count

    def_delegators :items, :[], :[]=, :empty?, :size, :each
    def_delegators :raw_response, :response, :request

    def initialize(response, options={})
      @raw_response = response
      parsed = JSON.parse(response.body)
      @total_record_count = parsed["total_record_count"]
      @options = options
      @mms_id = @options.delete(:mms_id)
      @items = parsed.fetch(key, []).map { |item| single_record_class.new(item) }
    end

    def grouped_by_library
      group_by(&:library)
    end

    def filter_missing_and_lost
      clone = dup
      clone.items = reject(&:missing_or_lost?)
      clone
    end

    def all
      Enumerator.new do |yielder|
        offset = 0
        loop do
          r = (offset == 0) ? self : single_record_class.find(@mms_id, options=@options.merge({limit: 100, offset: offset}))
          unless r.empty?
            r.map { |item| yielder << item }
            offset += 100
          else
            raise StopIteration
          end
        end
      end
    end

    def each(&block)
       @items.each(&block)
    end

    def success?
      raw_response.response.code.to_s == "200"
    end

    def key
      "item"
    end

    def single_record_class
      Alma::BibItem
    end
  end
end
