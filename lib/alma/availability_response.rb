module Alma
  class AvailabilityResponse


    attr_accessor :bibs

    def initialize(response)
      @bibs = response.list
      @inventory_type_to_subfield_codes_to_fieldnames = {
        'AVA' => {
            'INVENTORY_TYPE' => 'physical',
            'a' => 'institution',
            'b' => 'library_code',
            'c' => 'location',
            'd' => 'call_number',
            'e' => 'availability',
            'f' => 'total_items',
            'g' => 'non_available_items',
            'j' => 'location_code',
            'k' => 'call_number_type',
            'p' => 'priority',
            'q' => 'library',
        },
        'AVD' => {
            'INVENTORY_TYPE' => 'digital',
            'a' => 'institution',
            'b' => 'representations_id',
            'c' => 'representation',
            'd' => 'repository_name',
            'e' => 'label',
        },
        'AVE' => {
            'INVENTORY_TYPE' => 'electronic',
            'l' => 'library_code',
            'm' => 'collection',
            'n' => 'public_note',
            's' => 'coverage_statement',
            't' => 'interface_name',
            'u' => 'link_to_service_page',
        }
      }
    end

    def parse_bibs_data
      require 'pry'

      inventory_types = @inventory_type_to_subfield_codes_to_fieldnames.keys



      bibs.map do |bib|
        record = Hash.new


        record['mms_id'] = bib.id




        inventory_fields = bib.record.fetch('datafield', []).select { |df| inventory_types.member?(df['tag']) } || []

        record['holdings'] = inventory_fields.map do |inventory_field|
          inventory_type = inventory_field['tag']
          subfield_codes_to_fieldnames = @inventory_type_to_subfield_codes_to_fieldnames[inventory_type]

          # make sure subfields is always an Array (which isn't the case if there's only one subfield element)
          subfields = [ inventory_field.fetch('subfield', []) ].flatten(1)

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
        acc[avail['mms_id']] = avail.select { |k,v| k != 'mms_id' }
        acc
      end
    end


  end
end