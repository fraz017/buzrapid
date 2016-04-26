Rails.application.routes.draw do
  mount Rubyception::Engine => '/rubyception'
  resources :companies
  get 'home/index'

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root to: "home#index"
  get '/hr' => 'home#hr'
  get '/home/add_hr' => 'home#add_hr'
  get '/home/add_user' => 'home#add_user'
  post '/home/save_user' => 'home#save_user'
  post '/home/update_user' => 'home#update_user'
  delete '/home/delete_user' => 'home#delete_user'
  delete '/home/delete_project' => 'home#delete_project'
  get '/home/edit_user' => 'home#edit_user'
  get '/employees' => 'home#employees'
  get '/home/new_project' => 'home#new_project'
  post '/home/save_project' => 'home#save_project'
  get '/home/edit_project' => 'home#edit_project'
  post '/home/update_project' => 'home#update_project'
  get '/home/show_excel' => 'home#show_excel'
  get '/ongoing_projects' => 'home#ongoing_projects'
  get '/completed_projects' => 'home#completed_projects'
  post '/home/save_record' => 'home#save_record'
  get '/edit_record' => 'home#edit_record'
  delete '/home/delete_record' => 'home#delete_record'
  delete '/home/delete_scrap' => 'home#delete_scrap'
  get '/home/market_value' => 'home#market_value'
  post '/home/update_market_value' => 'home#update_market_value'
  post '/save_market_value' => 'home#save_market_value'
  get 'scrap_data' => 'home#scrap_data'
  post 'save_scrap_data' => 'home#save_scrap_data'
  post 'update_final_value' => 'home#update_final_value'
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
