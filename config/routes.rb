Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#create'
      resources :users, only: [:create, :show, :update] do
        patch '/profile_picture', to: 'users#profile_picture'
        post '/email', to: 'users#email'
        resources :images, only: [:create, :destroy]
        get :profile_picture, on: :member
        resources :executors, only: [:create, :update, :destroy, :index]
        resources :recipients, only: [:create, :update, :destroy, :index]
      end
    end
  end
end
