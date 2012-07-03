Communificiency::Application.routes.draw do
  get "sessions/new"

  resources :payments
  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  root :to => 'static_pages#home'

  match '/projects', to: 'static_pages#desc'

  match '/sign_in', to: "sessions#new"
  match '/sign_out', to: "sessions#destroy"

  match '/home', to:"static_pages#home"
  match '/help', to: "static_pages#help"
  match '/about', to: "static_pages#about"
  match '/contact', to: "static_pages#contact"

  match "/sign_up", to: "users#sign_up"
  match "/users", to: "users#create"

  match "/projects/:id", to: "static_pages#desc", params: :id

  match '/projects/1', to: "static_pages#desc"
  match '/projects/1/pay', to: "static_pages#pay"

  match '/confirm_payment_cbui', to: "payments#confirm_payment_cbui"


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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
