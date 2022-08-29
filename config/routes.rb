Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  apipie
 # default_url_options :host => Rails.application.config.action_controller.default_url_options[:host]
  
  resource :users, only: [:create]
  post '/login', to: 'users#login'
  post '/auto_login', to: 'users#auto_login'
  
  #resource :purchases
  get '/purchases', to: 'purchases#index'
  get '/purchases/top_sellings', to: 'purchases#top_sellings'
end
