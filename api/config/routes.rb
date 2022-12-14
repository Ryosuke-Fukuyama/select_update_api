Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # resources :hello, only: [:index]
      namespace 'users' do
        resources :registrations, only: [:create]
      end
      resources :properties, only: [:index, :show, :update]
    end
  end
end
