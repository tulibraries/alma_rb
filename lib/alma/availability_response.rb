module Alma
  class AvailabilityResponse


    attr_accessor :availability

    def initialize(response)
      @availability = parse_bibs_data(response.list)
    end

    def parse_bibs_data(bibs)

      inventory_types = Alma.INVENTORY_TO_SUBFIELD_TO_FIELDNAME.keys


      bibs.map do |bib|
        record = Hash.new

        record['mms_id'] = bib.id

        inventory_fields = bib.record.fetch('datafield', []).select { |df| inventory_types.member?(df['tag']) } || []

        record['holdings'] = inventory_fields.map do |inventory_field|
          inventory_type = inventory_field['tag']
          subfield_codes_to_fieldnames = @inventory_type_to_subfield_codes_to_fieldnames[inventory_type]

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
        record
      end.reduce(Hash.new) do |acc, avail|
        acc[avail['mms_id']] = avail.select { |k, v| k != 'mms_id' }
        acc
      end
    end
  end
end