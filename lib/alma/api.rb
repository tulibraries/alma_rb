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
      @resources ||= load_wadl
    end

    def load_wadl(wadl_filename = nil)
      wadl_filename ||= set_wadl_filename
      parsed_wadl = EzWadl::Parser.parse(File.join(Alma::WADL_DIR, wadl_filename)) do |rs|
        rs.first.path = Alma.configuration.region
      end
      parsed_wadl.first
    end

    def set_wadl_filename
      # Each class including this module should define this
      raise NotImplementedError 'You must define the wadl_filename method'
    end

  end
end
