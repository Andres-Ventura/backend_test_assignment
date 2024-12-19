class CarSortingService
  def initialize(cars, user)
    @cars = cars
    @user = user
  end

  def sort
    cars.sort_by do |car|
      [
        label_priority(car),
        rank_score_priority(car),
        price_priority(car)
      ]
    end
  end

  private

  attr_reader :cars, :user

  def label_priority(car)
    # Lower number = higher priority
    case CarLabelService.new(car: car, user: user).determine_label
    when 'perfect_match' then 0
    when 'good_match'   then 1
    else                     2
    end
  end

  def rank_score_priority(car)
    # Negative because we want highest rank first
    -(car.rank_score_for_user(user.id) || 0)
  end

  def price_priority(car)
    car.price || Float::INFINITY  # Put nil prices last
  end
end