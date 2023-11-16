# frozen_string_literal: true

module Alma
  class << self
    attr_accessor :configuration
  end

  def self.configure()
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
    on_configure
  end

  def self.on_configure
    _configure_logging
    _configure_debugging
  end

  def self._configure_logging
    if configuration.enable_log_requests
      primo_logger = configuration.logger
      log_level = Alma.configuration.log_level
      log_format = Alma.configuration.log_format
      Net.logger primo_logger, log_level, log_format
    end
  end

  def self._configure_debugging
    if configuration.enable_debug_output
      Net.debug_output configuration.debug_output_stream
    end
  end

  class Configuration
    attr_accessor :apikey, :region, :enable_loggable
    attr_accessor :timeout, :http_retries, :logger
    attr_accessor :timeout, :http_retries, :logger
    attr_accessor :log_level, :log_format, :debug_output_stream
    attr_accessor :enable_log_requests, :enable_debug_output

    def initialize
      @apikey = "TEST_API_KEY"
      @region = "https://api-na.hosted.exlibrisgroup.com"
      @enable_loggable = false
      @timeout = 5
      @http_retries = 3
      @log_level = :info
      @log_format = :logstash
      @logger = Logger.new(STDOUT)
      @enable_log_requests = false
      @enable_debug_output = false
      @log_level = :info
      @log_format = :logstash
      @debug_output_stream = $stderr
    end
  end
end
