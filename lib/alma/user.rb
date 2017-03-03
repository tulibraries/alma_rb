module Alma
  class  User < AlmaRecord
    extend Alma::Api

    attr_accessor :id

    def post_initialize
      @id = response['primary_id'].to_s
      @recheck_loans = true
    end

    def fines
      self.class.get_fines({user_id: self.id})
    end

    def loans
      unless @loans && !recheck_loans?
        @loans = self.class.get_loans({user_id: self.id})
        @recheck_loans = false
      end
      @loans
    end

    def renew_loan(loan_id)
      response = self.class.renew_loan({user_id: self.id, loan_id: loan_id})
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

    def requests
      self.class.get_requests({user_id:self.id})
    end

    class << self
      # Static methods that do the actual querying

      def find(args = {})
        #TODO Handle Search Queries
        #TODO Handle Pagination
        #TODO Handle looping through all results

        return find_by_id(user_id: args[:user_id]) if args.fetch(:user_id, nil)
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
      # @option args [String] :loan_id The unique id of the loan
      # @option args [String] :user_id_type Type of identifier being used to search. OPTIONAL
      # @return [RenewalResponse] Object indicating the renewal message
      def renew_loan(args)
        args.merge!({op: 'renew'})
        params = query_merge args
        response = resources.almaws_v1_users.user_id_loans_loan_id.post(params)
        RenewalResponse.new(response)
      end

      # Attempts to renew a multiple items for a user
      # @param [Hash] args
      # @option args [String] :user_id The unique id of the user
      # @option args [Array<String>] :loan_ids Array of loan ids
      # @option args [String] :user_id_type Type of identifier being used to search. OPTIONAL
      # @return [Array<RenewalResponse>] Object indicating the renewal message
      def renew_multiple_loans(args)

        if args.fetch(:loans_ids, nil).respond_to? :map
          args.delete(:loan_ids).map do |loan_id|
            renew_loan(args.merge(loan_id: loan_id))
          end
        else
          []
        end
      end




      def set_wadl_filename
        'user.wadl'
      end
    end
  end
end