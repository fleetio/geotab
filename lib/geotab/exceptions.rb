module Geotab
  class IncorrectCredentialsError < StandardError; end
  class MissingOrInvalidConnectionError < StandardError; end
  class ApiError < StandardError; end
end
