Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # namespace :customers do
      #   resources :find, only: [:show]
      # end
      namespace :customers do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
      end
      resources :customers, only: [:index, :show]
    end
  end
end
