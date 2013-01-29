Project::Application.routes.draw do
  resources :conferences
  
  resources :academic_titles

  resources :protocol_templates

  resources :dictionaries

  resources :degrees

  resources :emails

  resources :auditories

  resources :posts

  resources :participans

  resources :themes

  resources :protocols

  resources :employees

  resources :users

  resource :session, :only => [:new, :create, :destroy]

  match 'signup' => 'users#new', :as => :signup

  match 'register' => 'users#create', :as => :register

  match 'login' => 'sessions#new', :as => :login

  match 'logout' => 'sessions#destroy', :as => :logout
  
  match 'get_number' => 'protocols#get_number'

  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  
  post "versions/:id/revert" => "versions#revert", :as => "revert_version"
  
  resources :versions do 
    member { get 'revert' }
  end
  
  resources :protocols do
    member do
      get 'set_sign'   
      get 'versions'         
    end
    collection do
      post 'set_template'
      post 'change_view'
    end    
  end

  resources :users do
    collection { post 'update_roles' }
  end

  resources :protocol do
    collection do     
      get 'set_sign'      
    end    
  end
  
  resources :employees do
    member do
      get 'delete'      
    end
  end    
  
  root :to => "protocols#index"

#  resources :protocols do
#    member do
#       get 'set_signed'
#  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
