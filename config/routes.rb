Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "dashboard", to: "dashboard#index"
  post "dashboard/chat", to: "dashboard#chat"
  root "pages#home"

  resources :accounts, only: [:new, :create, :edit, :update] do
    resources :users, only: [:new, :create, :edit, :update]
    resources :staff, only: [:new, :create]
    collection do
      get :onboarding_settings
      post :add_default_step
      delete "remove_default_step/:id", action: :remove_default_step, as: :remove_default_step
    end
  end

  resources :intakes, only: [:index, :new, :create, :edit, :update] do
    resources :tasks, only: [:create, :update, :destroy]
    collection do
      post :import
    end
  end
  resources :tasks, only: [:index]
  resources :applicants, only: [:index, :new, :create, :edit, :update, :destroy] do
    member do
      patch :move
    end
    collection do
      post :add_step
      patch "toggle_step/:id", action: :toggle_step, as: :toggle_step
      delete "remove_step/:id", action: :remove_step, as: :remove_step
    end
  end
  get "applicant_portal", to: "applicant_portal#show"
  resources :call_transcripts, only: [:index, :show]

  get   "login", to: "sessions#new"
  post   "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :password_resets, only: [:edit, :update], param: :token

  post '/webhooks/elevenlabs', to: 'webhooks#elevenlabs_callback'
end
