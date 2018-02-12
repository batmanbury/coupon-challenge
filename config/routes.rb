Rails.application.routes.draw do
  root to: 'main#landing'

  devise_for :users

  resources :coupons, except: [:edit, :update, :show]

  # For autocompletion in coupons#new
  get '/coupons/brand_select', to: 'coupons#brand_select', as: 'brand_select'

  resources :transfers, only: [:index]
  resources :users, only: [:index]

  # User coupons
  get '/my-coupons', to: 'users#coupons', as: 'user_coupons'
  # Request a coupon
  post '/coupons/:id/request_coupon', to: 'coupons#request_coupon', as: 'request_coupon'
  # For dataTables views
  post '/coupons/as_json', to: 'coupons#as_json'
  post '/transfers/as_json', to: 'transfers#as_json'
  post '/users/as_json', to: 'users#as_json'
  # Stripe deposit
  post '/users/create_charge', to: 'users#create_charge'
end
