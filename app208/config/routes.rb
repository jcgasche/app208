App208::Application.routes.draw do



  root  'static_pages#home'


  match '/angel_callback',                  to: 'users#login_angelco',         via: 'get'
  match '/login_email/:email',              to: 'users#login_email',           via: 'post'
  match '/login_twitter/:twitter_id',       to: 'users#login_twitter',         via: 'post'



  match '/user/:user_id',                   to: 'users#show',                         via: 'post'

  match '/user/:user_id/companies',         to: 'users#followed_companies',           via: 'post'

  match '/user/:user_id/company/:company_id',
                                            to: 'users#display_company',              via: 'post'

  match '/user/:user_id/company/:company_id/follow',
                                            to: 'users#follow_company',               via: 'post'

  match '/user/:user_id/company/:company_id/notfollow',
                                            to: 'users#notfollow_company',            via: 'post'


  match '/refill_companies_db',             to: 'companies#fill_db',                  via: 'get'
  match '/refill/:limit/companies',         to: 'companies#fill_db',                  via: 'get'
  match '/companies',                       to: 'companies#index',                    via: 'get'

  match '/terms',                       to: 'static_pages#privacy',                    via: 'get'
  match '/privacy',                       to: 'static_pages#privacy',                    via: 'get'




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
