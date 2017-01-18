

module Alma
  class  User < AlmaRecord
    extend Alma::Api

    attr_accessor :id

    def post_initialize
      @id = response['primary_id']
    end

    def fines
      Alma::User.get_fines({:user_id => self.id.to_s})
    end

    def loans
      Alma::User.get_loans({:user_id => self.id.to_s})
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


      def set_wadl_filename
        'user.wadl'
      end
    end
  end
end