module Alma
  class  User
    extend Forwardable

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

    #
    # def renew_loan(loan_id)
    #   response = self.class.renew_loan({user_id: self.id, loan_id: loan_id})
    #   if response.renewed?
    #     @recheck_loans ||= true
    #   end
    #   response
    # end
    #
    # def renew_multiple_loans(loan_ids)
    #   loan_ids.map { |id| renew_loan(id) }
    # end
    #
    # def renew_all_loans
    #   renew_multiple_loans(loans.map(&:loan_id))
    # end
    #
    # def recheck_loans?
    #   @recheck_loans
    # end
    #
    def requests
      self.class.requests(id)
    end

    class << self
      # Static methods that do the actual querying

      def find(user_id)
        response = HTTParty.get("#{users_base_path}/#{user_id}", headers: headers)
        if response.code == 200
          User.new body(response)
        else
          raise StandardError, body(response)
        end
      end

      def fines(user_id)
        #TODO Handle Additional Parameters
        #TODO Handle Pagination
        #TODO Handle looping through all results
        response = HTTParty.get("#{users_base_path}/#{user_id}/fees", headers: headers)
        if response.code == 200
          Alma::FineSet.new body(response)
        else
          raise StandardError, body(response)
        end
      end

      def loans(user_id)
        #TODO Handle Additional Parameters
        #TODO Handle Pagination
        #TODO Handle looping through all results
        response = HTTParty.get("#{users_base_path}/#{user_id}/loans", headers: headers)
        Alma::LoanSet.new(body(response))
      end

      def requests(user_id)
        #TODO Handle Additional Parameters
        #TODO Handle Pagination
        #TODO Handle looping through all results
        response = HTTParty.get("#{users_base_path}/#{user_id}/requests", headers: headers)
        Alma::RequestSet.new(body(response))
      end


      private
      def body(response)
        JSON.parse(response.body)
      end


      def users_base_path
        "https://api-na.hosted.exlibrisgroup.com/almaws/v1/users"
      end

      def headers
        { "Authorization": "apikey #{apikey}",
          "Accept": "application/json",
          "Content-Type": "application/json" }
      end

      def apikey
        Alma.configuration.apikey
      end




      #
      #
      # def authenticate(args)
      #   # Authenticates a Alma user with their Alma Password
      #   args.merge!({op: 'auth'})
      #   params = query_merge args
      #   response = resources.almaws_v1_users.user_id.post(params)
      #   response.code == 204
      # end
      #
      # # Attempts to renew a single item for a user
      # # @param [Hash] args
      # # @option args [String] :user_id The unique id of the user
      # # @option args [String] :loan_id The unique id of the loan
      # # @option args [String] :user_id_type Type of identifier being used to search. OPTIONAL
      # # @return [RenewalResponse] Object indicating the renewal message
      # def renew_loan(args)
      #   args.merge!({op: 'renew'})
      #   params = query_merge args
      #   response = resources.almaws_v1_users.user_id_loans_loan_id.post(params)
      #   RenewalResponse.new(response)
      # end
      #
      # # Attempts to renew a multiple items for a user
      # # @param [Hash] args
      # # @option args [String] :user_id The unique id of the user
      # # @option args [Array<String>] :loan_ids Array of loan ids
      # # @option args [String] :user_id_type Type of identifier being used to search. OPTIONAL
      # # @return [Array<RenewalResponse>] Object indicating the renewal message
      # def renew_multiple_loans(args)
      #
      #   if args.fetch(:loans_ids, nil).respond_to? :map
      #     args.delete(:loan_ids).map do |loan_id|
      #       renew_loan(args.merge(loan_id: loan_id))
      #     end
      #   else
      #     []
      #   end
      # end


    end
  end
end
