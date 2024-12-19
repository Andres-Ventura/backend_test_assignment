class CarRecommendationService
  def call
    validate_inputs!
    fetch_and_process_cars
  rescue Redis::CannotConnectError => e
    Rails.logger.error "Cache error: #{e.message}"
    fetch_and_process_cars(skip_cache: true)
  end

  private

  def validate_inputs!
    raise CarRecommendationsError::InvalidParameters, "Invalid price range" if invalid_price_range?
    raise CarRecommendationsError::InvalidParameters, "Invalid page number" if page < 1
  end

  def invalid_price_range?
    return false if price_min.blank? || price_max.blank?
    price_min > price_max
  end

  def fetch_and_process_cars(skip_cache: false)
    cars = if skip_cache
             process_cars
           else
             Rails.cache.fetch(cache_key, expires_in: 15.minutes) { process_cars }
           end
    
    paginate_cars(cars)
  end
end