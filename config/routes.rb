Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/login', to: 'sessions#create'
      resources :users, only: [:create, :show, :update] do
        patch '/profile_picture', to: 'users#profile_picture'
        get :profile_picture, on: :member
        resources :executors, only: [:create, :update, :destroy, :index]
      end
    end
  end
end
