module Alma
  module UserRequests

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

    # Attempts to renew a single item for a user
    # @param [Hash] args
    # @option args [String] :user_id The unique id of the user
    # @option args [String] :loan_id The unique id of the loan
    # @option args [String] :user_id_type Type of identifier being used to search. OPTIONAL
    # @return [RenewalResponse] Object indicating the renewal message
    def renew_loan(args)
      user_id = args.delete(:user_id) { raise ArgumentError }
      loan_id = args.delete(:loan_id) { raise ArgumentError }
      params = {op: 'renew'}
      response = HTTParty.post("#{users_base_path}/#{user_id}/loans/#{loan_id}", query: params, headers: headers)
      RenewalResponse.new(body(response))
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


    # Authenticates a Alma user with their Alma Password
    # @param [Hash] args
    # @option args [String] :user_id The unique id of the user
    # @option args [String] :password The users local alma password
    # @return [Boolean] Whether or not the user Successfully authenticated
    def authenticate(args)
      user_id = args.delete(:user_id) { raise ArgumentError }
      args.merge!({op: 'auth'})
      response = HTTParty.post("#{users_base_path}/#{user_id}", query: args, headers: headers)
      response.code == 204
    end

    def save!(user_id, content)
      response = HTTParty.put("#{users_base_path}/#{user_id}", headers: headers, body: content.to_json)
      body(response)
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
  end
end
