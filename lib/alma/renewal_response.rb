module Alma
  class RenewalResponse

    def initialize(response)
      @raw_response = response
      @response = response.parsed_response
      @success  = response.has_key?('loan_id')
    end

    def loggable
      { uri: @raw_response&.request&.uri.to_s
      }.select { |k, v| !(v.nil? || v.empty?) }
    end

    def renewed?
      @success
    end

    def has_error?
      !renewed?
    end

    def due_date
      @response.fetch('due_date', '')
    end


    def due_date_pretty
      Time.parse(due_date).strftime('%m-%e-%y %H:%M')
    end

    def item_title
      if renewed?
        @response['title']
      else
        'This Item'
      end
    end

    def message
      if renewed?
        "#{item_title} is now due #{due_date}"
      else
        "#{item_title} could not be renewed."
      end
    end

    def error_message
        @response unless renewed?
    end

  end
end
