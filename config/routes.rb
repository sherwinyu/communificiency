Communificiency::Application.routes.draw do

  devise_for :users

  match '/caseus', to: 'projects#show', id: 1
  match '/projects/caseus', to: 'projects#show', id: 1
  match '/projects/1', to: 'projects#show', id: 1

  resources :user_signups, only: [:create]
  match '/home', to:"static_pages#home"
  match "/sign_up_old", to: "users#new"
  match "/users", to: "users#create"
  match '/about', to: "static_pages#about"
  root to: "static_pages#home"

  match '/praemonitus/:id', to: 'projects#show'
  devise_scope :user do
    match '/sign_up', to: "devise/registrations#new"
    match '/sign_in', to: "devise/sessions#new"
    match '/sign_out', to: "devise/sessions#destroy"
  end

  match '/coming_soon' => 'static_pages#coming_soon'

  resources :projects do
    resources :contributions
  end
  match '/*e' => 'static_pages#coming_soon'

  resources :rewards
  resources :contributions
  resources :projects

  # get "sessions/new"

  resources :payments
  resources :users, only: [:show, :index]
  # TODO(syu) add other users resources under admin scope
  # external user signup (new/create) and editing (edit/update) will be handled by the devise controller
  # However, we still want admins to be able to add/edit users arbitrarily, which we will do through this
  
  resources :sessions, only: [:new, :create, :destroy]

  root :to => redirect('http://signup.communificiency.com')



  # match '/sign_in_old', to: "sessions#new"

  match '/help', to: "static_pages#help"
  match '/contact', to: "static_pages#contact"


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
