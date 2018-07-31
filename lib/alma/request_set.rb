module Alma
  class RequestSet < Alma::Enumerable
    extend Forwardable

    attr_reader :response
    def_delegators :response, :[], :fetch

    def total_record_count
      fetch('total_record_count', 0)
    end

    alias :total_records :total_record_count

    def key
      'user_request'
    end

  end
end
