module Alma
  class  Bib
    extend Forwardable
    
    def self.find(ids, args)
      get_bibs(ids, args)
    end

    def self.get_bibs(ids, args={})
      response = HTTParty.get(
        self.bibs_base_path, 
        query: {mms_id: ids_from_array(ids)}, 
        headers: headers
        )

      if response.code == 200
        Alma::BibSet.new(get_body_from(response))
      else
        raise StandardError, get_body_from(response)
      end  
    end


    def self.get_availability(ids, args={})
      args.merge!({expand: 'p_avail,e_avail,d_avail'})
      bibs = get_bibs(ids, args)

      Alma::AvailabilityResponse.new(bibs)
    end



    attr_accessor :id, :response

    # The User object can respond directly to Hash like access of attributes
    def_delegators :response, :[], :[]=, :has_key?, :keys, :to_json, :each

    def initialize(response_body)
      @response = response_body
      @id = @response['mms_id'].to_s
    end

    # The raw MARCXML record, converted to a Hash
    def record
      @record ||= XmlSimple.xml_in(response['anies'].first)
    end


      private

      def self.bibs_base_path
        "#{self.region}/almaws/v1/bibs"
      end

      def bibs_base_path
        self.class.bibs_base_path
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
      
      def self.region
        Alma.configuration.region
      end

      def self.get_body_from(response)
        JSON.parse(response.body)
      end

      def self.ids_from_array(ids)
        ids.map(&:to_s).map(&:strip).join(',')
      end
  end
end
