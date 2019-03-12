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
      end
    end
  end
end
