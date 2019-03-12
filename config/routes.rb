Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
        get 'random', to: 'random#show'
      end
      resources :customers, only: [:index, :show] do
        get 'invoices', to: 'customers/invoices#index'
        get 'transactions', to: 'customers/transactions#index'
        get 'favorite_merchant', to: 'customers/favorite_merchant#show'
      end
    end
  end
end
