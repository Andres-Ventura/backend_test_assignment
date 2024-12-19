module CarRecommendationsError
  class Base < StandardError
    attr_reader :status, :code, :message

    def initialize(message = nil, status = nil, code = nil)
      @message = message || "An unexpected error occurred"
      @status = status || :internal_server_error
      @code = code || "ERROR_#{status}".upcase
      super(@message)
    end

    def serializable_hash
      {
        error: {
          code: code,
          message: message
        }
      }
    end
  end

  class NotFound < Base
    def initialize(message = "Resource not found")
      super(message, :not_found, "ERROR_NOT_FOUND")
    end
  end

  class InvalidParameters < Base
    def initialize(message = "Invalid parameters provided")
      super(message, :unprocessable_entity, "ERROR_INVALID_PARAMETERS")
    end
  end

  class ExternalServiceError < Base
    def initialize(message = "External service is temporarily unavailable")
      super(message, :service_unavailable, "ERROR_EXTERNAL_SERVICE")
    end
  end

  class RateLimitExceeded < Base
    def initialize(message = "Rate limit exceeded")
      super(message, :too_many_requests, "ERROR_RATE_LIMIT")
    end
  end
end