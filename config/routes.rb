Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :car_recommendations, only: :index
    end
  end
end