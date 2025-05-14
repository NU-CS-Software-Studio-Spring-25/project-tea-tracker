Rails.application.routes.draw do
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#dashboard"

  # Tea resources with all CRUD actions
  resources :teas do
    collection do
      get :count
    end
  end
  resources :entries

  # user authentication
  resources :users, only: [ :new, :create, :show ]
  resources :sessions, only: [ :new, :create, :destroy ]
  delete "/logout", to: "sessions#destroy", as: :logout
  get "/logout", to: "sessions#destroy"

  get "/analytics", to: "home#analytics", as: "tea_analytics"
  get "/categories", to: "teas#categories", as: "categories"
  get "/origins", to: "teas#origins", as: "origins"
  get "/price_statistics", to: "home#price_statistics", as: "price_statistics"
end
