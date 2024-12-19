class Car < ApplicationRecord
  belongs_to :brand

  scope :with_brands, -> { includes(:brand) }
  
  scope :price_range, ->(min, max) do
    return all if min.blank? && max.blank?
    
    range_conditions = []
    range_conditions << "price >= #{sanitize_sql(min)}" if min.present?
    range_conditions << "price <= #{sanitize_sql(max)}" if max.present?
    
    where(range_conditions.join(' AND '))
  end
  
  scope :by_brand_name, ->(query) do
    return all if query.blank?
    
    joins(:brand)
      .where('LOWER(brands.name) LIKE :query', query: "%#{query.downcase}%")
  end

  # Cache rank scores
  def rank_score_for_user(user_id)
    Rails.cache.fetch("car_rank:#{id}:user:#{user_id}", expires_in: 24.hours) do
      ExternalRecommendationService.new(user_id).fetch_recommendations[id]
    end
  end
end