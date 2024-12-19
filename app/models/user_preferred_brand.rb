class UserPreferredBrand < ApplicationRecord
  belongs_to :user
  belongs_to :brand

  validates :user_id, uniqueness: { scope: :brand_id }
end
