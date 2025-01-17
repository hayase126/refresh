Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#top"
  # user
  resources :users, only: %i[new create]
  resource :profile, only: %i[show edit update]
  # post
  resources :posts do
    get :search, on: :collection
    resources :comments, only: %i[create destroy], shallow: true
    collection do
      get :likes
    end
  end
  # like
  resources :likes, only: %i[create destroy]
  # login
  get "login" => "user_sessions#new", :as => :login
  post "login" => "user_sessions#create"
  delete "logout" => "user_sessions#destroy", :as => :logout
  # お問い合わせ
  get '/form', to: 'static_pages#form', as: :inquiry_form
  get '/policy', to: 'static_pages#policy', as: :privacy_policy
  get '/term', to: 'static_pages#term', as: :term
  # Google 認証
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", as: :auth_at_provider
end
