Tarai::Application.routes.draw do

  get "friends/list", :as => :friends
  get "friends/add", :as => :add_friend
  post "friends/add", :as => :add_friend
  post "friends/create", :as => :create_friend
  get "friends/search", :as => :serach_friend

  devise_scope :user do
    get "users/show", :to => "registrations#show", :as => :show_user_registration
  end
  devise_for :users, 
    :controllers => {
      :sessions => "sessions", 
      :registrations => "registrations",
      :passwords => "passwords"
  }

  get 'messages/sended_list', :as => :sended_messages
  get 'messages/mark_list', :as => :mark_messages
  get 'messages/received_list', :as => :received_messages
  get 'messages/select_user', :as => :select_user
  match 'messages/:id/new' => "messages#new", :as => :new_message

  resources :messages do 
    collection do 
      get 'sended_list', :as => :sended
      get 'mark_list', :as => :mark
      get 'received_list', :as => :received
    end
    member do
      get 'view'
      post 'reject'
    end
    resources :feedbacks, :only => [:index, :new, :create]
  end

  match "/auth/twitter/callback" => "twitter_sessions#create"
  match "/auth/twitter_out" => "twitter_sessions#destroy", :as => :twitter_out
  match "/auth/failure" => "twitter_sessions#failure"

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
  # root :to => "welcome#index"
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
