Hyperledger::Application.routes.draw do
  resources :ledgers, only: [:show, :index, :create], param: :name
  resources :accounts,   only: [:show, :index, :create], param: :code
  resources :issues,     only: [:show, :create]
  resources :transfers,  only: [:show, :create]
end
