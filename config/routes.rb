Mintet::Application.routes.draw do
  resources :currencies, only: [:show, :index, :create], param: :name
  resources :accounts,   only: [:show, :index, :create], param: :code
  resources :issues,     only: [:show, :create]
end
