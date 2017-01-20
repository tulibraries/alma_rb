

module Alma
  class  User < AlmaRecord
    extend Alma::Api

    attr_accessor :id

    def post_initialize
      @id = response['primary_id']
      @recheck_loans = true
    end

    def fines
      Alma::User.get_fines({:user_id => self.id.to_s})
    end

    def loans
      unless @loans && !recheck_loans?
        @loans = Alma::User.get_loans({:user_id => self.id.to_s})
        @recheck_loans = false
      end
      @loans
    end

    def renew_loan(loan)
      response = self.class.renew_loan({user_id: self.id.to_s, loan: loan})
      @recheck_loans = true if response.renewed?
      response
    end

    def recheck_loans?
      @recheck_loans
    end

    def requests
      Alma::User.get_requests({:user_id => self.id.to_s})
    end

    class << self
      # Static methods that do the actual querying

      def find(args = {})
        #TODO Handle Search Queries
        #TODO Handle Pagination
        #TODO Handle looping through all results

        return find_by_id(:user_id => args[:user_id]) if args.fetch(:user_id, nil)
        params = query_merge args
        response = resources.almaws_v1_users.get(params)
        Alma::UserSet.new(response)
      end

      def find_by_id(user_id_hash)
        params = query_merge user_id_hash
        response = resources.almaws_v1_users.user_id.get(params)
        User.new(response['user'])
      end

      def get_fines(args)
        #TODO Handle Additional Parameters
        #TODO Handle Pagination
        #TODO Handle looping through all results
        params = query_merge args
        response = resources.almaws_v1_users.user_id_fees.get(params)
        Alma::FineSet.new(response)
      end

      def get_loans(args)
        #TODO Handle Additional Parameters
        #TODO Handle Pagination
        #TODO Handle looping through all results
        params = query_merge args
        response = resources.almaws_v1_users.user_id_loans.get(params)
        Alma::LoanSet.new(response)
      end

      def get_requests(args)
        #TODO Handle Additional Parameters
        #TODO Handle Pagination
        #TODO Handle looping through all results
        params = query_merge args
        response = resources.almaws_v1_users.user_id_requests.get(params)
        Alma::RequestSet.new(response)
      end

      def authenticate(args)
        # Authenticates a Alma user with their Alma Password
        args.merge!({op: 'auth'})
        params = query_merge args
        response = resources.almaws_v1_users.user_id.post(params)
        response.code == 204
      end

      # Attempts to renew a single item for a user
      # @param [Hash] args
      # @option args [String] :user_id The unique id of the user
      # @option args [String] :loan_id The unique id of the loan - optional (either :loan_id or :loan must be present)
      # @option args [String] :loan_id A loan object - optional (either :loan_id or :loan must be present)
      # @option args [String] :user_id_type Type of identifier being used to search

      # @return [RenewalResponse] Object indicating the renewal message
      def renew_loan(args)
        args.merge!({op: 'renew'})
        loan = args.delete(:loan)
        if loan
          args[:loan_id] = loan.loan_id
        end
        params = query_merge args
        response = resources.almaws_v1_users.user_id_loans_loan_id.post(params)
        RenewalResponse.new(response, loan)
      end


      def set_wadl_filename
        'user.wadl'
      end
    end
  end
end