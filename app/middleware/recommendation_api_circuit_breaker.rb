class RecommendationApiCircuitBreaker
  def initialize(app)
    @app = app
  end

  def call(env)
    if circuit_open?
      return [503, {}, ['Recommendation service temporarily unavailable']]
    end

    @app.call(env)
  rescue StandardError => e
    mark_failure
    [503, {}, ['Service temporarily unavailable']]
  end

  private

  def circuit_open?
    Rails.cache.read('recommendation_api_failures').to_i >= 3
  end

  def mark_failure
    Rails.cache.increment('recommendation_api_failures', expires_in: 5.minutes)
  end
end