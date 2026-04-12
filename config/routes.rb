Rails.application.routes.draw do
  # Authentication
  resource :session
  resources :passwords, param: :token
  resources :users, only: [ :new, :create ]

  # Main app routes
  resources :conversations do
    resources :messages, only: [ :create ]
    member do
      patch :update_title
    end
  end

  # Stack management
  resources :stacks, only: [ :index, :create, :destroy ]

  # Billing/Upgrade
  resources :billing, only: [ :index ]
  post "/billing/checkout", to: "billing#checkout", as: :checkout
  get "/billing/success", to: "billing#success", as: :billing_success
  get "/billing/cancel", to: "billing#cancel", as: :billing_cancel

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "conversations#index"
end
