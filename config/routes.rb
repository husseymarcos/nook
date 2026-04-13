Rails.application.routes.draw do
  resources :chats do
    resources :messages, only: [ :create ]
  end

  resources :models, only: [ :index, :show ] do
    collection do
      post :refresh
    end
  end
  # Authentication
  resource :session
  resources :passwords, param: :token
  resources :users, only: [ :new, :create ]

  # Stack management
  resources :stacks do
    resources :stack_tools, only: [ :create, :destroy ], as: :tools
  end

  # Billing/Upgrade
  resources :billing, only: [ :index ]
  post "/billing/checkout", to: "billing#checkout", as: :checkout
  get "/billing/success", to: "billing#success", as: :billing_success
  get "/billing/cancel", to: "billing#cancel", as: :billing_cancel

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "chats#index"
end
