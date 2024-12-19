RSpec.describe 'Car Recommendations API', type: :request do
  describe 'GET /api/v1/car_recommendations' do
    context 'with invalid parameters' do
      it 'returns error for missing user_id' do
        get api_v1_car_recommendations_path
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error][:code]).to eq('ERROR_INVALID_PARAMETERS')
      end

      it 'returns error for invalid price range' do
        get api_v1_car_recommendations_path, 
            params: { user_id: 1, price_min: 50000, price_max: 20000 }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error][:message]).to include('price range')
      end
    end

    context 'when rate limited' do
      it 'returns rate limit error after too many requests' do
        101.times do
          get api_v1_car_recommendations_path, params: { user_id: 1 }
        end

        expect(response).to have_http_status(:too_many_requests)
      end
    end
  end
end