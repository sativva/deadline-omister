Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  root to: 'pages#home'
  require "sidekiq/web"
  mount Sidekiq::Web => '/sidekiq'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'products', to: 'products#index'

    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
