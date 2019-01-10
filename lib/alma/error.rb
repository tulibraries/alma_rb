module Alma::Error

  def has_error?
    !error.empty?
  end

  def error_message
    (has_error?) ? error['errorList']['error']['errorMessage'] : ''
  end

  def error
    @response.fetch('web_service_result', {})
  end
end

module Alma
  class StandardError < ::StandardError
    def initialize(message, loggable = {})
      if Alma.configuration.enable_loggable
        message = { error: message }.merge(loggable).to_json
      end

      super message
    end
  end
end
