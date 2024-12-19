module Api
  module V1
    class CarRecommendationsController < ApplicationController
      include ErrorHandler

      def index
        validate_parameters!
        check_rate_limit!

        cars = fetch_recommendations
        render json: format_response(cars)
      end

      private

      def validate_parameters!
        raise CarRecommendationsError::InvalidParameters, "User ID is required" if params[:user_id].blank?
        
        if params[:price_min].present? && params[:price_max].present?
          raise CarRecommendationsError::InvalidParameters, "Maximum price must be greater than minimum price" if params[:price_max].to_i <= params[:price_min].to_i
        end
      end

      def check_rate_limit!
        key = "rate_limit:#{request.ip}:#{Time.current.to_i / 60}"
        count = Rails.cache.increment(key, 1, expires_in: 1.minute)
        
        raise CarRecommendationsError::RateLimitExceeded if count > 100
      end

      def fetch_recommendations
        CarRecommendationService.new(
          user: User.find(params[:user_id]),
          **recommendation_params
        ).call
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        raise CarRecommendationsError::ExternalServiceError, "Recommendation service timeout"
      end

      def recommendation_params
        params.permit(:query, :price_min, :price_max, :page).to_h.symbolize_keys
      end

      def format_response(cars)
        {
          cars: ActiveModel::Serializer::CollectionSerializer.new(
            cars,
            serializer: CarRecommendationSerializer,
            user: current_user
          ),
          meta: pagination_meta(cars)
        }
      end

      def pagination_meta(cars)
        {
          current_page: cars.current_page,
          total_pages: cars.total_pages,
          total_count: cars.total_count
        }
      end
    end
  end
end