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

    def initialize
      @apikey = "TEST_API_KEY"
      @region = 'https://api-na.hosted.exlibrisgroup.com'
      @enable_loggable = false
    end
  end
end
