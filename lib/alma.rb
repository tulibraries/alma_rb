# frozen_string_literal: true

require "alma/version"
require "alma/config"
require "alma/api_defaults"
require "alma/error"
require "alma/alma_record"
require "alma/response"
require "alma/user"
require "alma/bib"
require "alma/loan"
require "alma/result_set"
require "alma/loan_set"
require "alma/user_set"
require "alma/fine_set"
require "alma/fine"
require "alma/bib_set"
require "alma/request_set"
require "alma/renewal_response"
require "alma/availability_response"
require "alma/bib_item"
require "alma/request_options"
require "alma/item_request_options"
require "alma/request"
require "alma/user_request"
require "alma/electronic"
require "alma/bib_holding"
require "alma/library"
require "alma/library_set"
require "alma/location"
require "alma/location_set"
require "alma/course_set"
require "alma/course"

module Alma
  require "httparty"

  ROOT = File.dirname __dir__
end
