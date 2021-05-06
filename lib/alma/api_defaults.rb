# frozen_string_literal: true

module Alma
  module ApiDefaults
    def apikey
      Alma.configuration.apikey
    end

    def region
      Alma.configuration.region
    end

    def headers
      { "Authorization": "apikey #{self.apikey}",
      "Accept": "application/json",
      "Content-Type": "application/json" }
    end

    def bibs_base_path
      "#{self.region}/almaws/v1/bibs"
    end

    def users_base_path
      "#{self.region}/almaws/v1/users"
    end

    def items_base_path
      "#{self.region}/almaws/v1/items"
    end

    def configuration_base_path
      "#{self.region}/almaws/v1/conf"
    end

    def timeout
      Alma.configuration.timeout
    end
  end
end
