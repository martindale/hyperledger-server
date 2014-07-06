Hyperledger::Application.routes.draw do
  
  concern :confirmable do
    collection do
      post :prepare
      post :commit
    end
  end
  
  resources :ledgers,   only: [:show, :index, :create], param: :name, concerns: :confirmable
  resources :accounts,  only: [:show, :index, :create], param: :code
  resources :issues,    only: [:show, :create]
  resources :transfers, only: [:show, :create]
  
end
