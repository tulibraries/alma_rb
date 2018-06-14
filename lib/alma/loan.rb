module Alma
  class Loan < AlmaRecord


    def renewable?
      !!renewable
    end

    def overdue?
      loan_status == "Overdue"
    end

    def renew
      Alma::User.renew_loan({user_id: user_id, loan_id: loan_id})
    end

  end
end
