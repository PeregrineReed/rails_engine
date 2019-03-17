Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # Customers
      namespace :customers do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random', to: 'random#show'
      end
      resources :customers, only: [:index, :show] do
        get 'invoices', to: 'customers/invoices#index'
        get 'transactions', to: 'customers/transactions#index'
        get 'favorite_merchant', to: 'customers/favorite_merchant#show'
      end

      # Merchants
      namespace :merchants do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random', to: 'random#show'
        get 'revenue', to: 'revenue/date#index'
        get 'most_revenue', to: 'most_revenue/quantity#index'
        get 'most_items', to: 'most_items/quantity#index'
      end
      resources :merchants, only: [:index, :show] do
        get 'items', to: 'merchants/items#index'
        get 'invoices', to: 'merchants/invoices#index'
        get 'revenue', to: 'merchants/revenue/date#show', constraints: ->(request) { request.query_parameters[:date].present? }
        get 'revenue', to: 'merchants/revenue#show'
        get 'favorite_customer', to: 'merchants/favorite_customer#show'
      end

      #Items
      namespace :items do
        get 'most_revenue', to: 'most_revenue/quantity#index'
        get 'most_items', to: 'most_items/quantity#index'
      end
      resources :items, only: [:index, :show] do
        get 'best_day', to: 'items/best_day#show'
      end

      #Invoices
      namespace :invoices do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random', to: 'random#show'
      end
      resources :invoices, only: [:index, :show] do
        get 'transactions', to: 'invoices/transactions#index'
        get 'invoice_items', to: 'invoices/invoice_items#index'
        get 'items', to: 'invoices/items#index'
        get 'customer', to: 'invoices/customer#show'
        get 'merchant', to: 'invoices/merchant#show'
      end

      #Invoice Items
      namespace :invoice_items do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random', to: 'random#show'
      end
      resources :invoice_items, only: [:index, :show] do
        get 'invoice', to: 'invoice_items/invoice#show'
        get 'item', to: 'invoice_items/item#show'
      end
    end
  end
end
