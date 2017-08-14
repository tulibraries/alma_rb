module Alma
  class  User
    extend Forwardable
    extend UserRequests

   # The User object can respond directly to Hash like access of attributes
   def_delegators :response, :[], :has_key?, :keys

    def initialize(response_body)
      @response = response_body
      @recheck_loans = true
    end


    def method_missing(name)
      return response[name.to_s] if has_key?(name.to_s)
      super.method_missing name
    end

    def respond_to_missing?(name, include_private = false)
      has_key?(name.to_s) || super
    end

    def id
      primary_id
    end

    def response
      @response
    end


    def fines
      self.class.fines(id)
    end

    def loans
      unless @loans && !recheck_loans?
        @loans = self.class.loans(id)
        @recheck_loans = false
      end
      @loans
    end

    def email
      u = self.class.find(id)
      u["contact_info"]["email"].first["email_address"]
    end

    def expire_email!
      u = self.class.find(id)
      u["contact_info"]["email"].first["email_address"] = "blank@expired.temple.edu"
      response = self.class.update_user(id, u.response)
    end

    #
    def renew_loan(loan_id)
      response = self.class.renew_loan({user_id: id, loan_id: loan_id})
      if response.renewed?
        @recheck_loans ||= true
      end
      response
    end

    def renew_multiple_loans(loan_ids)
      loan_ids.map { |id| renew_loan(id) }
    end

    def renew_all_loans
      renew_multiple_loans(loans.map(&:loan_id))
    end

    def recheck_loans?
      @recheck_loans
    end
    #
    def requests
      self.class.requests(id)
    end

  end
end
