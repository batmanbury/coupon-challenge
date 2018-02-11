Rails.application.routes.draw do
  root to: 'main#landing'

  devise_for :users

  resources :coupons, except: [:edit, :update, :show]
  resources :transfers, only: [:index]
  resources :users, only: [:index]

  post '/coupons/:id/request_coupon', to: 'coupons#request_coupon', as: 'request_coupon'
  post '/coupons/as_json', to: 'coupons#as_json'
  post '/transfers/as_json', to: 'transfers#as_json'
  post '/users/as_json', to: 'users#as_json'
end
