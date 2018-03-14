module Alma
  class BibSet

    extend Forwardable
    include Enumerable
    #include Alma::Error

    attr_reader :response
    def_delegators :list, :each, :size
    def_delegators :response, :[], :fetch

    def initialize(response_body_hash)
      @response = response_body_hash
    end

    def list
      @list ||= response.fetch(key, []).map do |record|
        Alma::Bib.new(record)
      end
    end

    def key
      'bib'
    end

    def total_record_count
      size
    end

  end
end
