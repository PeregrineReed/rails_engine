Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # namespace :customers do
      #   resources :find, only: [:show]
      # end
      get 'customers/find', to: 'customers/find#show'
      get 'customers/find_all', to: 'customers/find#index'
      resources :customers, only: [:index, :show]
    end
  end
end
