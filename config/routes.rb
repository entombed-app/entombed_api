Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#create'
      resources :users, only: [:create, :show, :update] do
        patch '/profile_picture', to: 'users#profile_picture'
        post '/attach_image', to: 'users#attach_image'
        get :profile_picture, on: :member
        resources :executors, only: [:create, :update, :destroy, :index]
      end
    end
  end
end
