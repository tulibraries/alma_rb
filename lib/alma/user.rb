module Alma
  class  User
    extend Forwardable

      def self.find(user_id, args={})
        args[:expand] ||= "fees,requests,loans"
        response = HTTParty.get("#{self.users_base_path}/#{user_id}", query: args, headers: headers)
        if response.code == 200
          Alma::User.new JSON.parse(response.body)
        else
          raise StandardError, JSON.parse(response.body)
        end
      end

      # Authenticates a Alma user with their Alma Password
      # @param [Hash] args
      # @option args [String] :user_id The unique id of the user
      # @option args [String] :password The users local alma password
      # @return [Boolean] Whether or not the user Successfully authenticated
      def self.authenticate(args)
        user_id = args.delete(:user_id) { raise ArgumentError }
        args.merge!({op: 'auth'})
        response = HTTParty.post("#{users_base_path}/#{user_id}", query: args, headers: headers)
        response.code == 204
      end


    # The User object can respond directly to Hash like access of attributes
    def_delegators :response, :[], :[]=, :has_key?, :keys, :to_json

    def initialize(response_body)
      @response = response_body
    end

    def response
      @response
    end

    def id
      self['primary_id']
    end

    def total_fines
      response.dig('fees','value') || "0"
    end

    def total_requests
      response.dig('requests','value') || "0"
    end

    def total_loans
      response.dig('loans','value') || "0"
    end


    # Access the top level JSON attributes as object methods
    def method_missing(name)
      return response[name.to_s] if has_key?(name.to_s)
      super.method_missing name
    end

    def respond_to_missing?(name, include_private = false)
      has_key?(name.to_s) || super
    end


    # Persist the user in it's current state back to Alma
    def save!
      response = HTTParty.put("#{users_base_path}/#{id}", headers: headers, body: to_json)
      get_body_from(response)
    end


    def fines
      Alma::Fine.where_user(id)
    end

    def requests
      Alma::UserRequest.where_user(id)
    end


    def loans(args={})
        @loans ||= Alma::Loan.where_user(id, args)
    end

    def renew_loan(loan_id)
      response = self.class.send_loan_renewal_request({user_id: id, loan_id: loan_id})
      if response.renewed?
        @recheck_loans ||= true
      end
    end


    def renew_multiple_loans(loan_ids)
      loan_ids.map { |id| renew_loan(id) }
    end

    def renew_all_loans
      renew_multiple_loans(loans.map(&:loan_id))
    end

    def preferred_email
      self["contact_info"]["email"].select { |k, v| k["preferred"] }.first["email_address"]
    end


    def email
      self["contact_info"]["email"].map { |e| e["email_address"] }
    end


    private

    # Attempts to renew a single item for a user
    # @param [Hash] args
    # @option args [String] :user_id The unique id of the user
    # @option args [String] :loan_id The unique id of the loan
    # @option args [String] :user_id_type Type of identifier being used to search. OPTIONAL
    # @return [RenewalResponse] Object indicating the renewal message
    def self.send_loan_renewal_request(args)
      loan_id = args.delete(:loan_id) { raise ArgumentError }
      user_id = args.delete(:user_id) { raise ArgumentError }
      params = {op: 'renew'}
      response = HTTParty.post("#{users_base_path}/#{user_id}/loans/#{loan_id}", query: params, headers: headers)
      RenewalResponse.new(JSON.parse(response.body))
    end

    # Attempts to renew multiple items for a user
    # @param [Hash] args
    # @option args [String] :user_id The unique id of the user
    # @option args [Array<String>] :loan_ids The unique ids of the loans
    # @option args [String] :user_id_type Type of identifier being used to search. OPTIONAL
    # @return [Array<RenewalResponse>] Array of Objects indicating the renewal messages
    def self.send_multiple_loan_renewal_requests(args)
      loan_ids = args.delete(:loan_ids) { raise ArgumentError }
      loan_ids.map { |id| Alma::User.send_loan_renewal_request(args.merge(loan_id: id))}
    end

    def get_body_from(response)
      JSON.parse(response.body)
    end


    def self.users_base_path
      "https://api-na.hosted.exlibrisgroup.com/almaws/v1/users"
    end

    def users_base_path
      self.class.users_base_path
    end

    def self.headers
      { "Authorization": "apikey #{self.apikey}",
      "Accept": "application/json",
      "Content-Type": "application/json" }
    end


    def headers
      self.class.headers
    end


    def self.apikey
      Alma.configuration.apikey
    end

  end
end
