module Alma
  class Loan < AlmaRecord
    extend Alma::ApiDefaults


    def renewable?
      !!response["renew"]
    end

    def overdue?
      loan_status == "Overdue"
    end

    def renew
      Alma::User.renew_loan({user_id: user_id, loan_id: loan_id})
    end

    def self.fetch(user_id, args={})
      # Always expand renewable unless you really don't want to
      args["expand"] ||= "renewable"
      # Its safer to just ask for all of them
      args["limit"] ||= 100
      response = HTTParty.get(
        "#{users_base_path}/#{user_id}/loans",
        query: args,
        headers: headers
        )
      Alma::LoanSet.new(response)
    end


  end
end
