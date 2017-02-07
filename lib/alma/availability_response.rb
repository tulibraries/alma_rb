module Alma
  class AvailabilityResponse


    attr_accessor :availability

    def initialize(response)
      @availability = parse_bibs_data(response.list)

    end

    def parse_bibs_data(bibs)

      bibs.map do |bib|
        record = Hash.new

        record['mms_id'] = bib.id
        record['holdings'] = build_holdings_for(bib)

        record
      end.reduce(Hash.new) do |acc, avail|
        acc[avail['mms_id']] = avail.select { |k, v| k != 'mms_id' }
        acc
      end
    end


    def build_holdings_for(bib)

      get_inventory_fields_for(bib).map do |inventory_field|
        subfield_codes_to_fieldnames = Alma::INVENTORY_TO_SUBFIELD_TO_FIELDNAME[inventory_field['tag']]

        # make sure subfields is always an Array (which isn't the case if there's only one subfield element)
        subfields = [inventory_field.fetch('subfield', [])].flatten(1)

        holding = subfields.reduce(Hash.new) do |acc, subfield|
          fieldname = subfield_codes_to_fieldnames[subfield['code']]
          acc[fieldname] = subfield['__content__']
          acc
        end
        holding['inventory_type'] = subfield_codes_to_fieldnames['INVENTORY_TYPE']
        holding
      end
    end

    def get_inventory_fields_for(bib)
      bib.record.fetch('datafield', []).select { |df| Alma::INVENTORY_TO_SUBFIELD_TO_FIELDNAME.key?(df['tag']) } || []
    end
  end
end
