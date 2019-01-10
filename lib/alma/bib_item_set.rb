# frozen_string_literal: true

module Alma

  class BibItemSet < ResultSet

    class ResponseError < ::Alma::StandardError
    end

    attr_accessor :items
    attr_reader :raw_response, :total_record_count

    def_delegators :items, :[], :[]=, :empty?, :size, :each
    def_delegators :raw_response, :response, :request

    def initialize(response, options={})
      @raw_response = response
      parsed = response.parsed_response
      @total_record_count = parsed["total_record_count"]
      @options = options
      @mms_id = @options.delete(:mms_id)

      validate(response)
      @items = parsed.fetch(key, []).map { |item| single_record_class.new(item) }
    end

    def loggable
      { total_record_count: @total_record_count,
        mms_id: @mms_id,
        uri: @raw_response&.request&.uri.to_s
      }.select { |k, v| !(v.nil? || v.empty?) }
    end

    def validate(response)
      if response.code != 200
        log = loggable.merge(response.parsed_response)
        raise ResponseError.new("Could not get bib items.", log)
      end
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
