Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # Customers
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

      # Merchants
      namespace :merchants do
        get 'revenue', to: 'revenue/date#index'
        get 'most_revenue', to: 'most_revenue/quantity#index'
        get 'most_items', to: 'most_items/quantity#index'
      end
      resources :merchants, only: [:index, :show] do
        get 'revenue', to: 'merchants/revenue/date#show', constraints: ->(request) { request.query_parameters[:date].present? }
        get 'revenue', to: 'merchants/revenue#show'
        get 'favorite_customer', to: 'merchants/favorite_customer#show'
      end

    end
  end
end
