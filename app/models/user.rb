class User < ApplicationRecord
  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_brands, through: :user_preferred_brands, source: :brand

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :preferred_price_range, presence: true

  def price_range_min
    preferred_price_range&.begin
  end

  def price_range_max
    preferred_price_range&.end
  end

  def price_matches?(price)
    preferred_price_range&.include?(price)
  end
end
