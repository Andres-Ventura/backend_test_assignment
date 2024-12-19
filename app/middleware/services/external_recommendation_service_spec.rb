require 'rails_helper'

RSpec.describe ExternalRecommendationService do
  let(:user_id) { 1 }
  let(:service) { described_class.new(user_id) }

  describe '#fetch_recommendations' do
    context 'when API is available' do
      before do
        stub_request(:get, /bravado-images-production/)
          .to_return(
            status: 200,
            body: [
              { car_id: 1, rank_score: 0.9 },
              { car_id: 2, rank_score: 0.8 }
            ].to_json
          )
      end

      it 'returns parsed recommendations' do
        expect(service.fetch_recommendations).to eq(
          1 => 0.9,
          2 => 0.8
        )
      end
    end

    context 'when API is unavailable' do
      before do
        stub_request(:get, /bravado-images-production/)
          .to_timeout
      end

      it 'returns empty hash' do
        expect(service.fetch_recommendations).to eq({})
      end
    end
  end
end