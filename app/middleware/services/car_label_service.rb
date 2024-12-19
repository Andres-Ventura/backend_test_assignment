class CarLabelService
  def initialize(car:, user:)
    @car = car
    @user = user
  end

  def determine_label
    return 'perfect_match' if perfect_match?
    return 'good_match' if good_match?
    nil
  end

  private

  attr_reader :car, :user

  def perfect_match?
    brand_match? && price_match?
  end

  def good_match?
    brand_match?
  end

  def brand_match?
    user.preferred_brands.include?(car.brand)
  end

  def price_match?
    user.preferred_price_range.include?(car.price)
  end
end