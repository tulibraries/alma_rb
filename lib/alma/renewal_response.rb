module Alma
  class RenewalResponse

    def initialize(response, loan=nil)
      @loan     = loan
      @success  = response.fetch('item_loan', nil)
      @error    = response.fetch('web_service_result', nil)
      @renewed  = @error.nil?
    end

    def renewed?
      @renewed
    end

    def new_due_date
      Time.parse(@success['due_date']).strftime('%m-%e-%y %H:%M')
    end

    def error_message
      @error['errorList']['error']['errorMessage']
    end

    def item_title
      if @loan
        @loan.title
      else
        "This Item"
      end
    end

    def message
      if @success
        "#{item_title} is now due #{new_due_date}"
      else
        "#{item_title} could not be renewed."
      end
    end
  end
end