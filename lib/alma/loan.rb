module Alma
  class Loan < AlmaRecord
    extend Alma::ApiDefaults


    def renewable?
      !!renewable
    end

    def renewable
      response.fetch("renewable", false)
    end

    def overdue?
      loan_status == "Overdue"
    end

    def renew
      Alma::User.renew_loan({user_id: user_id, loan_id: loan_id})
    end

    def self.fetch(user_id, args={})
      # Always expand renewable unless you really don't want to
      args[:expand] ||= "renewable"
      # Default to upper limit
      args[:limit] ||= 100
      response = HTTParty.get(
        "#{users_base_path}/#{user_id}/loans",
        query: args,
        headers: headers
        )
      Alma::LoanSet.new(response)
    end


  end
end
