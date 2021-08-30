Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        get :profile_picture, on: :member
      end 
      resources :user, only: [:show]
    end
  end
end
