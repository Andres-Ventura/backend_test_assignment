require 'rails_helper'

RSpec.describe Car do
  describe 'associations' do
    it { should belong_to(:brand) }
  end

  describe 'scopes' do
    describe '.price_range' do
      let!(:cheap_car) { create(:car, price: 10_000) }
      let!(:medium_car) { create(:car, price: 30_000) }
      let!(:expensive_car) { create(:car, price: 50_000) }

      it 'filters by minimum price' do
        expect(Car.price_range(20_000, nil)).to contain_exactly(medium_car, expensive_car)
      end

      it 'filters by maximum price' do
        expect(Car.price_range(nil, 40_000)).to contain_exactly(cheap_car, medium_car)
      end
    end

    describe '.by_brand_name' do
      let!(:toyota) { create(:brand, name: 'Toyota') }
      let!(:tesla) { create(:brand, name: 'Tesla') }
      let!(:toyota_car) { create(:car, brand: toyota) }
      let!(:tesla_car) { create(:car, brand: tesla) }

      it 'filters by partial brand name match' do
        expect(Car.by_brand_name('Toy')).to contain_exactly(toyota_car)
      end
    end
  end
end