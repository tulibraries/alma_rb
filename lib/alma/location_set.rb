# frozen_string_literal: true

module Alma
  class LocationSet < ResultSet
    def_delegators :results, :[], :empty?

    def each(&block)
       results.each(&block)
    end

    def results
      @results ||= @response.fetch(key, [])
        .map { |item| single_record_class.new(item) }
    end

    protected
      def key
        "location"
      end
  end
end
