

module Alma
  class  User < AlmaResponse
    extend Alma::Api


    def fines
      Alma::User.fines({:user_id => self.id.to_s})
    end

    def loans
      Alma::User.loans({:user_id => self.id.to_s})
    end


    class << self
      def find(args = {})
        #TODO Handle Search Queries
        #TODO Handle Pagination
        #TODO Handle looping through results

        return find_by_id(:user_id => args[:user_id]) if args.fetch(:user_id, nil)
        params = query_merge args
        response = resources.almaws_v1_users.get(params)

        Struct.new('Users', :total_results, :list ).new(
            response['users']['total_record_count'],
            response['users']['user'].map {|user| Alma::User.new(user)}
        )
      end

      def find_by_id(user_id_hash)
        params = query_merge user_id_hash
        response = resources.almaws_v1_users.user_id.get(params)
        User.new(response['user'])
      end

      def fines(args)
        #TODO Handle Additional Parameters
        params = query_merge args
        response = resources.almaws_v1_users.user_id_fees.get(params)
        Struct.new('Fines', :total_results, :sum, :currency, :list ).new(
            response['fees']['total_record_count'],
            response['fees']['total_sum'],
            response['fees']['currency'],
            response['fees'].fetch('fee',[]).map {|fee| Alma::AlmaResponse.new(fee)}
        )
      end

      def loans(args)
        params = query_merge args
        response = resources.almaws_v1_users.user_id_loans.get(params)
        Struct.new('Items', :list ).new(
             response['item_loans'].fetch('item_loan',[]).map {|fee| Alma::AlmaResponse.new(fee)}
        )
      end

      def wadl_filename
        'user.wadl'
      end
    end
  end
end