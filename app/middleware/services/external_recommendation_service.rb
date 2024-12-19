require 'net/http'

class ExternalRecommendationService
  RECOMMENDATION_URL = "https://bravado-images-production.s3.amazonaws.com/recomended_cars.json"
  CACHE_EXPIRY = 24.hours

  def initialize(user_id)
    @user_id = user_id
  end

  def fetch_recommendations
    Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRY) do
      fetch_from_api
    end
  rescue StandardError => e
    Rails.logger.error("Recommendation API error: #{e.message}")
    {}  # Return empty hash on error
  end

  private

  attr_reader :user_id

  def cache_key
    "user_recommendations:#{user_id}:#{Date.current}"
  end

  def fetch_from_api
    uri = URI(RECOMMENDATION_URL)
    uri.query = URI.encode_www_form(user_id: user_id)
    
    response = Net::HTTP.get_response(uri)
    
    return {} unless response.is_a?(Net::HTTPSuccess)
    
    JSON.parse(response.body).each_with_object({}) do |rec, hash|
      hash[rec['car_id']] = rec['rank_score']
    end
  end
end