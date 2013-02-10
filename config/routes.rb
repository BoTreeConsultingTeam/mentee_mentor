MentorMentee::Application.routes.draw do

  get "resources/create"

  root to: 'users#welcome'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "/signup" => "devise/registrations#new"
    get "/signin" => "devise/sessions#new"
    get "/signout" => "devise/sessions#destroy"
    get '/users/auth/:provider/disconnect' => "users/omniauth_callbacks#disconnect", as: :auth_disconnect
  end

  match "/home" => "users#index", as: :user_home

  resources :users do
    member do
      get "profile" => "users#show"
      get "profile/edit" => "users#edit"
      get "mboard"
      get 'all_dialogues/:with' => "users#all_dialogues", as: :dialogues_with
      post "follow/:follow_user_id" => "users#follow", as: :follow
    end

    resources :mquests
    resources :resources
  end

  resources :messages
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
