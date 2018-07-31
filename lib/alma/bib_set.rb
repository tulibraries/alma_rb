module Alma
  class BibSet
    extend Forwardable
    include Enumerable
    include Alma::Enumerable

    attr_reader :response
    def_delegators :list, :each, :size
    def_delegators :response, :[], :fetch

    def each
      @response.fetch(key, []).map { |item| Alma::Bib.new.(item) }
    end

    def key
      'bib'
    end

    def total_record_count
      size
    end
  end
end
