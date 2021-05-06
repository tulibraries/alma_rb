# frozen_string_literal: true

module Alma
  class << self
    attr_accessor :configuration
  end

  def self.configure()
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :apikey, :region, :enable_loggable
    attr_accessor :timeout, :http_retries, :logger

    def initialize
      @apikey = "TEST_API_KEY"
      @region = "https://api-na.hosted.exlibrisgroup.com"
      @enable_loggable = false
      @timeout = 5
      @http_retries = 3
      @logger = Logger.new(STDOUT)
    end
  end
end
