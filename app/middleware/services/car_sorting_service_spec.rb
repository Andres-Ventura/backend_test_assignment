require 'rails_helper'

RSpec.describe CarSortingService do
  let(:user) { create(:user, preferred_price_range: 20000..30000) }
  let(:preferred_brand) { create(:brand, name: 'Toyota') }
  let!(:user_preferred_brand) { create(:user_preferred_brand, user: user, brand: preferred_brand) }

  describe '#sort' do
    let!(:perfect_match_car) do
      create(:car, 
        brand: preferred_brand,
        price: 25000,
        rank_score: 0.5
      )
    end

    let!(:good_match_car) do
      create(:car,
        brand: preferred_brand,
        price: 35000,
        rank_score: 0.9
      )
    end

    let!(:no_match_car) do
      create(:car,
        brand: create(:brand),
        price: 20000,
        rank_score: 0.7
      )
    end

    it 'sorts cars by label priority first' do
      sorted_cars = described_class.new([no_match_car, perfect_match_car, good_match_car], user).sort
      expect(sorted_cars).to eq([perfect_match_car, good_match_car, no_match_car])
    end

    it 'sorts by rank score within same label' do
      # Create two perfect match cars with different rank scores
      perfect_match_1 = create(:car, brand: preferred_brand, price: 25000, rank_score: 0.3)
      perfect_match_2 = create(:car, brand: preferred_brand, price: 25000, rank_score: 0.8)

      sorted_cars = described_class.new([perfect_match_1, perfect_match_2], user).sort
      expect(sorted_cars).to eq([perfect_match_2, perfect_match_1])
    end

    it 'sorts by price within same label and rank score' do
      # Create two perfect match cars with same rank score but different prices
      perfect_match_1 = create(:car, brand: preferred_brand, price: 28000, rank_score: 0.5)
      perfect_match_2 = create(:car, brand: preferred_brand, price: 22000, rank_score: 0.5)

      sorted_cars = described_class.new([perfect_match_1, perfect_match_2], user).sort
      expect(sorted_cars).to eq([perfect_match_2, perfect_match_1])
    end
  end
end