Rails.application.routes.draw do
  # start jiinda method routes
  jinda_methods = ['pending','status','search','doc','logs','ajax_notice']
  jinda_methods += ['init','run','run_do','run_form','end_form','error_logs', 'notice_logs', 'cancel']
  jinda_methods.each do |aktion| get "/jinda/#{aktion}" => "jinda##{aktion}" end
  post '/jinda/init' => 'jinda#init'
  post '/jinda/pending' => 'jinda#index'
  post '/jinda/end_form' => 'jinda#end_form'
  mount Ckeditor::Engine => '/ckeditor'
  # end jinda method routes
  post '/auth/:provider/callback' => 'sessions#create'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy', :as => 'logout'
  get '/articles/my' => 'articles/my'
  get '/articles/my/destroy' => 'articles#destroy'
  resources :datacenters
  resources :countries
  resources :languages

  resources :articles
  resources :users
  resources :identities
  resources :sessions
  resources :password_resets
  resources :jinda, :only => [:index, :new]
  root :to => 'datacenters#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
