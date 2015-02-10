Tweets::Application.routes.draw do
 # get "hashtags/index"
 # get "hashtags/show"
  root 'static_pages#home'
  match '/help', to: 'static_pages#help',via: 'get'
  match '/about', to: 'static_pages#about',via: 'get'
  match '/contacts', to: 'static_pages#contacts',via: 'get'
  match '/signup', to: 'users#new',via: 'get' 
  match '/tops', to: 'static_pages#tops',via: 'get' 
  #Определение подстраниц для ресурса
  resources :users do
     #add user/id/following and user/id/followers
    member do
      get :following, :followers #add user/id/following and user/id/followers
      get :verification
      post :sent_verification_mail
    end
     #add user/otherpages (without id!!!)
     collection do
      get :reset_password
      post :recive_email_for_reset_pass
      post :resetpass_recive_pass
     end
  end

  resources :sessions, only: [:new, :create, :destroy];
  #resources :microposts, only: [:create, :destroy, :repost];
  resources :relationships, only:[:create, :destroy];
  resources :hashtags, only: [:create, :destroy, :index, :show];
  match '/signin', to: 'sessions#new', via:'get';
  match '/signout', to:'sessions#destroy', via:'delete';
#  post '/microposts/:id/repost' => 'microposts#repost', as: :repost
  resources :microposts, only: [:create, :destroy, :repost] do
    member do
      post :repost
    end
    collection do
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
