Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home/show'

  # Homepage
  root 'static_pages#home'

  # Static contents
  get "/pages/:page" => "static_pages#show"
  get "/pages/help/:page" => "static_pages#help"

  # Posts
  resources :posts do
    resources :comments
  end

  patch "/posts/:id/overdose" => "posts#overdose"
  patch "/posts/:id/shortage" => "posts#shortage"
  patch "/posts/:id/favorite" => "posts#favorite"

  devise_for :users, path: 'account', :controllers => { registrations: 'user_registrations' }

  resources :users, only: [:show, :edit, :update, :index]

end
