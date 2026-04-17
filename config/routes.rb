Rails.application.routes.draw do
  resources :chats do
    resources :messages, only: :create
  end

  resources :models, only: %i[ index show ]
  resource :models_refresh, only: :create, controller: "models/refreshes"

  resource :session
  resources :passwords, param: :token
  resources :users, only: %i[ new create ]

  resources :stacks do
    resources :stack_tools, only: %i[ create destroy ], as: :tools
  end

  resource :billing, only: :show, controller: :billing do
    resource :checkout, only: :create, module: :billing
    resource :success, only: :show, module: :billing, controller: :successes
    resource :cancellation, only: :show, module: :billing
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "chats#new"
end
