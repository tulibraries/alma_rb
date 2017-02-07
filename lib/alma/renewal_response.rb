module Alma
  class RenewalResponse

    include Alma::Error

    def initialize(response)
      @response = response
      @success  = response.fetch('item_loan', {})
      @renewed  = error.empty?
    end

    def renewed?
      @renewed
    end

    def due_date
      @success.fetch('due_date', '')
    end


    def due_date_pretty
      Time.parse(due_date).strftime('%m-%e-%y %H:%M')
    end

    def item_title
      if @success
        @success['title']
      else
        'This Item'
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