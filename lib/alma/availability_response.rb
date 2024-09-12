# frozen_string_literal: true

require "xmlsimple"

module Alma
  class AvailabilityResponse
    attr_accessor :availability

    def initialize(response)
      @availability = parse_bibs_data(response.each)
    end

    # Data structure for holdings information of bib records.
    # A hash with mms ids as keys, with values of an array of
    # one or more hashes of holdings info
    def parse_bibs_data(bibs)
      bibs.reduce(Hash.new) { |acc, bib|
        acc.merge({ "#{bib.id}" => { holdings: build_holdings_for(bib) } })
      }
    end

    def build_holdings_for(bib)
      holdings = []

      get_inventory_fields_for(bib).map do |inventory_field|
        h = {}

        # Use the mapping for this inventory type
        subfield_codes = Alma::INVENTORY_SUBFIELD_MAPPING[inventory_field["tag"]]
        h["inventory_type"] = subfield_codes["INVENTORY_TYPE"]

        inventory_field.
          # Get all the subfields for this inventory field
          fetch("subfield", []).
          # Limit to only subfields codes for which we have a mapping
          select { |sf| subfield_codes.key? sf["code"] }.each { |f|
          key = subfield_codes[f["code"]]
          if h.key? key
            h[key] << " " + f["content"]
          else
            h[key] = f["content"]
          end
        }
        holdings << h
      end
      holdings
    end

    def get_inventory_fields_for(bib)
      # Return only the datafields with tags AVA, AVD, or AVE
      bib.record
        .fetch("datafield", [])
        .select { |df| Alma::INVENTORY_SUBFIELD_MAPPING.key?(df["tag"]) }
    end
  end

  INVENTORY_SUBFIELD_MAPPING =
  {
     "AVA" => {
         "INVENTORY_TYPE" => "physical",
         "a" => "institution",
         "b" => "library_code",
         "c" => "location",
         "d" => "call_number",
         "e" => "availability",
         "f" => "total_items",
         "g" => "non_available_items",
         "j" => "location_code",
         "k" => "call_number_type",
         "p" => "priority",
         "q" => "library",
         "t" => "holding_info",
         "8" => "holding_id",
     },
     "AVD" => {
         "INVENTORY_TYPE" => "digital",
         "a" => "institution",
         "b" => "representations_id",
         "c" => "representation",
         "d" => "repository_name",
         "e" => "label",
     },
     "AVE" => {
         "INVENTORY_TYPE" => "electronic",
         "c" => "collection_id",
         "e" => "activation_status",
         "l" => "library_code",
         "m" => "collection",
         "n" => "public_note",
         "s" => "coverage_statement",
         "t" => "interface_name",
         "u" => "link_to_service_page",
         "8" => "portfolio_pid",
     }
 }
end
