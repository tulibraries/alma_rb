require 'alma/version'
require 'alma/config'
require 'alma/api'
require 'alma/alma_response'
require 'alma/user'

module Alma

  ROOT = File.dirname __dir__
  WADL_DIR = File.join(Alma::ROOT, 'lib','alma','wadl')

end
