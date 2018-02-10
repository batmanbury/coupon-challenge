Rails.application.routes.draw do
  root to: 'main#landing'

  devise_for :users

  resources :coupons, except: [:edit, :update, :show]
end
