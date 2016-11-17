Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home/show'

  # Homepage
  root 'static_pages#home'

  # Static contents
  get "/pages/:page" => "static_pages#show"
  get "/pages/help/:page" => "static_pages#help"

  # Posts
  get "/random" => "posts#random", as: :random
  resources :posts do
    resources :comments
  end

  patch "/posts/:id/report" => "posts#report", as: 'report_post'
  patch "/posts/:id/overdose" => "posts#overdose"
  patch "/posts/:id/shortage" => "posts#shortage"
  patch "/posts/:id/favorite" => "posts#favorite"

  #Admin Section
  scope :admin, as: :admin do
    root 'admin/dashboard#index', as: 'dashboard'

    get "stats" => "admin/dashboard#stats", as: 'stats'
    resources :users, controller: "admin/users", except: [:new, :create]
    resources :news, controller: "admin/news"
    resources :posts, controller:"admin/posts", except: [:new, :create]
    patch "/posts/:id/unreport" => "admin/posts#unreport", as: "post_unreport"
    resources :levels, controller: "admin/levels", except: [:destroy, :show]
    resources :comments, controller: "admin/comments", only: [:index, :destroy]
    patch "/comments/:id/unreport" => "admin/comments#unreport", as: "comment_unreport"

  end

  devise_for :users, path: 'account', :controllers => { registrations: 'user_registrations' }

  resources :users, only: [:show, :edit, :update, :index]

end
