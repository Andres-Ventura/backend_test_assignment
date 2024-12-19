require 'rails_helper'

RSpec.describe CarRecommendationService do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user: user) }

  describe '#call' do
    context 'with various filters' do
      let!(:perfect_match) do
        brand = create(:brand)
        create(:user_preferred_brand, user: user, brand: brand)
        create(:car, brand: brand, price: user.preferred_price_range.begin + 1000)
      end

      it 'returns cars in correct order' do
        result = service.call
        expect(result.first).to eq(perfect_match)
      end
    end
  end
end