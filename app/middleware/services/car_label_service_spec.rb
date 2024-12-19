require 'rails_helper'

RSpec.describe CarLabelService do
  let(:user) { create(:user, preferred_price_range: 20000..30000) }
  let(:preferred_brand) { create(:brand) }
  let!(:user_preferred_brand) { create(:user_preferred_brand, user: user, brand: preferred_brand) }

  describe '#determine_label' do
    it 'returns perfect_match when brand and price match' do
      car = create(:car, brand: preferred_brand, price: 25000)
      label = described_class.new(car: car, user: user).determine_label
      expect(label).to eq('perfect_match')
    end

    it 'returns good_match when only brand matches' do
      car = create(:car, brand: preferred_brand, price: 40000)
      label = described_class.new(car: car, user: user).determine_label
      expect(label).to eq('good_match')
    end

    it 'returns nil when neither matches' do
      car = create(:car, brand: create(:brand), price: 40000)
      label = described_class.new(car: car, user: user).determine_label
      expect(label).to be_nil
    end
  end
end