class Brand < ApplicationRecord
  has_many :cars, dependent: :destroy
  has_many :user_preferred_brands, dependent: :destroy
  has_many :users, through: :user_preferred_brands

  validates :name, presence: true, uniqueness: true
end
