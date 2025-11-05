Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  devise_scope :user do
    unauthenticated do
      root to: 'welcome#index', as: :unauthenticated_root
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check 
  get "welcome/index"
  get "home", to: "welcome#index", as: :home
  get "dashboard", to: "dashboard#index"
  namespace :guests do
    resources :reservas, only: [:index, :show]
  end
  get "minhas-reservas", to: "guests/reservas#index", as: :guest_reservas
  resources :hotels do
    collection do
      get :export
    end
    resources :room_types
    resources :quartos
  end

  resources :hospedes do
    collection do
      get :export
    end
    member do
      get :confirm_phone
      post :verify_phone
    end
  end

  resources :reservas do
    collection do
      get :export
      get :incompletas
      get :calendar
    end
    member do
      post :confirmar
      post :check_in
      post :check_out
      post :consumptions, action: :create_consumption
      patch "consumptions/:consumption_id", action: :update_consumption, as: :consumption
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "welcome#index"
end
