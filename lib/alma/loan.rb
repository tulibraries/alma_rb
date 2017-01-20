module Alma
  class Loan < AlmaRecord

    def renew
      Alma::User.renew_loan({user_id: user_id, loan: self})
    end

  end
end