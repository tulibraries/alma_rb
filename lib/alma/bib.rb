module Alma
  class  Bib < AlmaRecord
    extend Alma::Api

    attr_accessor :id, :record

    def post_initialize
      @id = response['mms_id'].to_s
      @record = response.fetch('record', {})
    end

    class << self

      def get_availability(ids, args={})
        args.merge!({expand: 'p_avail,e_avail,d_avail'})
        bibs = get_bibs(ids, args)

        return bibs if bibs.has_error?
        bibs
      end

      def find(ids, args)
        get_bibs(ids, args)
      end

      def get_bibs(ids, args={})
        args[:mms_id] = ids_from_array(ids)
        params = query_merge(args)
        response = resources.almaws_v1_bibs.get(params)

        Alma::BibSet.new(response)
      end

      private

      def ids_from_array(ids)
        ids.map(&:to_s).map(&:strip).join(',')
      end

      def set_wadl_filename
        'bib.wadl'
      end

    end
  end
end
