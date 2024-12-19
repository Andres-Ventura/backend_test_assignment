require 'rails_helper'

RSpec.describe 'Car Recommendations Performance', type: :request do
  let(:user) { create(:user) }
  
  before do
    # Create large dataset
    create_list(:car, 1000)
  end

  it 'handles large datasets efficiently' do
    start_time = Time.current
    get api_v1_car_recommendations_path, params: { user_id: user.id }
    end_time = Time.current

    expect(end_time - start_time).to be < 0.5 # Should respond within 500ms
  end
end