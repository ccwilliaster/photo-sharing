Project4::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'users#login'

  resources :users do
    # Want actions not new controllers, hence not using resources: login
    get :login,  on: :collection
    get :logout, on: :collection
    post :post_login, on: :collection

  end

  resources :photos do
    resources :comments
    resources :tags, :only => [:new, :create, :index]
    
    # ajax instant photo search
    get :search, on: :collection
  end
end
