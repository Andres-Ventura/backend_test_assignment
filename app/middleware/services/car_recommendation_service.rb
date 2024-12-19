class CarRecommendationService
  DEFAULT_PAGE_SIZE = 20
  MAX_PAGE_SIZE = 100

  def initialize(user:, query: nil, price_min: nil, price_max: nil, page: 1, per_page: DEFAULT_PAGE_SIZE)
    @user = user
    @query = sanitize_query(query)
    @price_min = normalize_price(price_min)
    @price_max = normalize_price(price_max)
    @page = [page.to_i, 1].max
    @per_page = [[per_page.to_i, MAX_PAGE_SIZE].min, 1].max
  end

  def call
    Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      fetch_cars
    end
  end

  private

  attr_reader :user, :query, :price_min, :price_max, :page, :per_page

  def fetch_cars
    cars = base_query
    cars = apply_filters(cars)
    cars = apply_sorting(cars)
    apply_pagination(cars)
  end

  def base_query
    Car.with_brands
  end

  def apply_filters(cars)
    cars
      .then { |scope| apply_brand_filter(scope) }
      .then { |scope| apply_price_filter(scope) }
  end

  def apply_pagination(cars)
    Kaminari.paginate_array(cars)
            .page(page)
            .per(per_page)
  end

  def cache_key
    components = [
      'car_recommendations',
      user.id,
      query,
      price_min,
      price_max,
      page,
      per_page,
      Car.maximum(:updated_at)&.to_i,
      user.updated_at.to_i
    ]
    
    Digest::MD5.hexdigest(components.join(':'))
  end
end