module Alma
  class UserSet

    attr_reader :total_record_count, :list

    def initialize(ws_response)
      @ws_response = ws_response
    end

    def total_record_count
      @ws_response['users'].fetch('total_record_count', 0)
    end

    def list
      @list ||= list_results
    end

    private
    def response_records
      @ws_response['users'].fetch('user',[])
    end

    def list_results
      response_records.map do |fee|
        Alma::AlmaRecord.new(fee)
      end
    end
  end
end