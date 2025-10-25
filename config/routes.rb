Rails.application.routes.draw do
 
  devise_for :users

# Redireciona para uma tela inicial customizada caso o usuário já esteja logado
  authenticated :user do
    root to: 'welcome#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new', as: :unauthenticated_root
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check 
  get "welcome/index"
  resources :hotels 
  resources :hospedes 
  resources :reservas 

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
