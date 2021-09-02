Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :show, :update] do
        get :profile_picture, on: :member
        resources :executors, only: [:create, :update, :destroy, :index]
      end 
    end
  end
end
