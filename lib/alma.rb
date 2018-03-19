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
require 'alma/bib_items'

module Alma

  ROOT = File.dirname __dir__
  WADL_DIR = File.join(Alma::ROOT, 'lib','alma','wadl')


end
