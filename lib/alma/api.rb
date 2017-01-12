require 'ezwadl'

module Alma
  module Api


    def default_params
      { :query => { :apikey => Alma.configuration.apikey } }
    end

    def query_merge(hash)
      {:query => default_params[:query].merge(hash)}
    end

    def resources
      @resources ||= EzWadl::Parser.parse(File.join(Alma::WADL_DIR, wadl_filename)).first
    end

    def wadl_filename
      # Each class including this module should define this
      raise NotImplementedError 'You must define the wadl_filename method'
    end

  end
end
