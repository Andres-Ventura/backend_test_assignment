module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      handle_error(e)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      handle_not_found(e)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      handle_validation_error(e)
    end

    rescue_from ActionController::ParameterMissing do |e|
      handle_parameter_missing(e)
    end
  end

  private

  def handle_error(error)
    case error
    when CarRecommendationsError::Base
      render json: error.serializable_hash, status: error.status
    when ActiveRecord::RecordNotFound
      handle_not_found(error)
    else
      handle_unexpected_error(error)
    end
  end

  def handle_not_found(error)
    render json: {
      error: {
        code: "ERROR_NOT_FOUND",
        message: error.message || "Resource not found"
      }
    }, status: :not_found
  end

  def handle_validation_error(error)
    render json: {
      error: {
        code: "ERROR_VALIDATION_FAILED",
        message: "Validation failed",
        details: error.record.errors.messages
      }
    }, status: :unprocessable_entity
  end

  def handle_parameter_missing(error)
    render json: {
      error: {
        code: "ERROR_PARAMETER_MISSING",
        message: error.message,
        parameter: error.param
      }
    }, status: :bad_request
  end

  def handle_unexpected_error(error)
    Rails.logger.error "Unexpected error: #{error.class} - #{error.message}"
    Rails.logger.error error.backtrace.join("\n")

    render json: {
      error: {
        code: "ERROR_INTERNAL_SERVER",
        message: "An unexpected error occurred"
      }
    }, status: :internal_server_error
  end
end