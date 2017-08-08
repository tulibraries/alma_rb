require 'alma/version'
require 'alma/config'
require 'alma/api'
require 'alma/error'
require 'alma/alma_record'
require 'alma/user'
require 'alma/bib'
require 'alma/loan'
require 'alma/result_set'
require 'alma/loan_set'
require 'alma/user_set'
require 'alma/fine_set'
require 'alma/user_set'
require 'alma/bib_set'
require 'alma/request_set'
require 'alma/renewal_response'
require 'alma/availability_response'

module Alma

  ROOT = File.dirname __dir__
  WADL_DIR = File.join(Alma::ROOT, 'lib','alma','wadl')

  INVENTORY_TO_SUBFIELD_TO_FIELDNAME =
   {
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
