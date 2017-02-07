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