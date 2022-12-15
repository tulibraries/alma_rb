# frozen_string_literal: true

require "httparty"
require "active_support"
require "active_support/core_ext"
require "alma/config"

module Alma
  # Alma::Electronic APIs wrapper.
  class Electronic
    class ElectronicError < ArgumentError
    end

    def self.get(params = {})
      retries_count = 0
      response = nil
      while retries_count < http_retries do
        begin
          response = get_api(params)
          break;

        rescue Net::ReadTimeout
          retries_count += 1
          log.error("Retrying http after timeout with : #{params}")
          no_more_retries_left = retries_count == http_retries

          raise Net::ReadTimeout.new("Failed due to net timeout after #{http_retries}: #{params}") if no_more_retries_left
        end
      end

      return response
    end

    def self.get_totals
      @totals ||= get(limit: "0").data["total_record_count"]
    end

    def self.log
      Alma.configuration.logger
    end

    def self.get_ids
      total = get_totals()
      limit = 100
      offset = 0
      log.info("Retrieving #{total} collection ids.")
      groups = Array.new(total / limit + 1, limit)
      @ids ||= groups.map { |limit|
        prev_offset = offset
        offset += limit
        { offset: prev_offset, limit: }
      }
        .map { |params|  Thread.new { self.get(params) } }
        .map(&:value).map(&:data)
        .map { |data| data["electronic_collection"].map { |coll| coll["id"] } }
        .flatten.uniq
    end

    def self.http_retries
      Alma.configuration.http_retries
    end

  private
    class ElectronicAPI
      include ::HTTParty
      include ::Enumerable
      extend ::Forwardable

      REQUIRED_PARAMS = []
      RESOURCE = "/almaws/v1/electronic"

      attr_reader :params, :data
      def_delegators :@data, :each, :each_pair, :fetch, :values, :keys, :dig,
        :slice, :except, :to_h, :to_hash, :[], :with_indifferent_access

      def initialize(params = {})
        @params = params
        headers = self.class::headers
        log.info(url:, query: params)
        response = self.class::get(url, headers:, query: params, timeout:)
        @data = JSON.parse(response.body) rescue {}
      end

      def url
        "#{Alma.configuration.region}#{resource}"
      end

      def timeout
        Alma.configuration.timeout
      end

      def log
        Alma::Electronic.log
      end

      def resource
        @params.inject(self.class::RESOURCE) { |path, param|
          key = param.first
          value = param.last

          if key && value
            path.gsub(/:#{key}/, value.to_s)
          else
            path
          end
        }
      end

      def self.can_process?(params = {})
        type = self.to_s.split("::").last.parameterize
        self::REQUIRED_PARAMS.all? { |param| params.include? param } &&
          params[:type].blank? || params[:type] == type
      end

    private
      def self.headers
        { "Authorization": "apikey #{apikey}",
         "Accept": "application/json",
         "Content-Type": "application/json" }
      end

      def self.apikey
        Alma.configuration.apikey
      end
    end

    class Portfolio < ElectronicAPI
      REQUIRED_PARAMS = [ :collection_id, :service_id, :portfolio_id ]
      RESOURCE = "/almaws/v1/electronic/e-collections/:collection_id/e-services/:service_id/portfolios/:portfolio_id"
    end

    class Service < ElectronicAPI
      REQUIRED_PARAMS = [ :collection_id, :service_id ]
      RESOURCE = "/almaws/v1/electronic/e-collections/:collection_id/e-services/:service_id"
    end

    class Services < ElectronicAPI
      REQUIRED_PARAMS = [ :collection_id, :type ]
      RESOURCE = "/almaws/v1/electronic/e-collections/:collection_id/e-services"
    end

    class Collection < ElectronicAPI
      REQUIRED_PARAMS = [ :collection_id ]
      RESOURCE = "/almaws/v1/electronic/e-collections/:collection_id"
    end

    # Catch all Electronic API.
    # By default returns all collections
    class Collections < ElectronicAPI
      REQUIRED_PARAMS = []
      RESOURCE = "/almaws/v1/electronic/e-collections"

      def self.can_process?(params = {})
        true
      end
    end

    # Order matters because parameters can repeat.
    REGISTERED_APIs = [Portfolio, Service, Services, Collection, Collections]

    def self.get_api(params)
      REGISTERED_APIs
        .find { |m| m.can_process? params }
        .new(params)
    end
  end
end
