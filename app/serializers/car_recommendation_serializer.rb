class CarRecommendationSerializer < ActiveModel::Serializer
  attributes :id, :model, :price, :rank_score, :label, :brand

  def brand
    {
      id: object.brand_id,
      name: object.brand.name
    }
  end

  def rank_score
    object.rank_score_for_user(current_user.id)
  end

  def label
    CarLabelService.new(car: object, user: current_user).determine_label
  end

  private

  def current_user
    @instance_options[:user]
  end
end