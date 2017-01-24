module Alma
  class  Bib < AlmaRecord
    extend Alma::Api

    class << self

      def get_availability(ids, args)
        bibs= get_bibs(ids, args)
        AvailabilityResponse.new(bibs)
      end

      def find(ids, args)
        BibSet.new(get_bibs(ids, args))
      end

      private

      def ids_from_array(ids)
        ids.map(&:to_s).map(&:strip).join(',')
      end

      def get_bibs(ids, args)
        args[:mms_id] = ids_from_array(ids)
        params = query_merge(args)
        resources.almaws_v1_bibs.get({ query: params })
      end

      def set_wadl_filename
        'bib.wadl'
      end

    end
  end
end
