module Alma
  class BibSet < Alma::Enumerable
    attr_reader :response

    def_delegators :response, :[], :fetch

    def each
      @list ||= @response.fetch(key, []).map { |item| Alma::Bib.new(item) }
    end

    def key
      'bib'
    end

    def total_record_count
      size
    end
  end
end
