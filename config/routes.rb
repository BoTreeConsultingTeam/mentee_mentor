MentorMentee::Application.routes.draw do

  root to: 'users#welcome'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "users/registrations" }

  devise_scope :user do
    get "/signup" => "devise/registrations#new"
    get "/signin" => "devise/sessions#new"
    get "/signout" => "devise/sessions#destroy"
    get '/users/auth/:provider/disconnect' => "users/omniauth_callbacks#disconnect", as: :auth_disconnect
  end

  match "/home" => "users#index", as: :user_home

  resources :users do
    member do
      post "upload_picture"
      post "update_status"
      get "refresh_timeline"
      get "profile" => "users#show"
      get "profile/edit" => "users#edit"
      put "change_password" => "users#change_password"
      get "mboard"
      post "follow/:follow_user_id" => "users#follow", as: :follow
      delete "unfollow/:following_user_id" => "users#unfollow", as: :unfollow
    end

    resources :mquests, only: [:index, :create]

    resources :resources
  end

  put "/mquests/:id/mark_as_read" => "mquests#mark_as_read", as: :mquest_mark_as_read
  put "/mquests/:id/mark_as_unread" => "mquests#mark_as_unread", as: :mquest_mark_as_unread

  resources :searches, only: [:index]

  resources :comments, only: [:index, :create]

  get 'statuses/:status_id/comments/:next_page' => 'comments#load_more_status_comments', as: :more_status_comments

  post 'statuses/:status_id/like' => 'likes#create', as: :like_status
  delete 'statuses/:status_id/dislike' => 'likes#destroy', as: :dislike_status

  get 'search' => "searches#index"

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
