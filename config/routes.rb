Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get 'home/show'

    # Homepage
    root 'application#home'

    # Static contents
    get "/pages/:page" => "static_pages#show", as: :static_page
    get "/pages/help/:page" => "static_pages#help", as: :static_help_page

    # Posts
    get "/random" => "posts#random", as: :random
    resources :posts do
        resources :comments
    end
    patch "/posts/:id/report" => "posts#report_update", as: 'report_post'
    get "/posts/:id/report" => "posts#report", as: 'edit_report_post'
    patch "/posts/:id/dose/:dose" => "posts#dose", as: 'post_dose'
    patch "/posts/:id/favorite" => "posts#favorite", as: 'post_favorite'

    # Artists
    resources :authors

    # Tags
    resources :tags

    # Comments
    patch "/posts/:post_id/comments/:comment_id/report" => "comments#report", as: "comment_report"

    #Admin Section
    scope :admin, as: :admin do
        root 'admin/dashboard#index', as: 'dashboard'

        get "stats" => "admin/dashboard#stats", as: 'stats'
        resources :users, controller: "admin/users", except: [:new, :create, :show]
        patch 'ban_user/:id', controller: "admin/users", action: :ban, as: 'user_ban'
        resources :news, controller: "admin/news"
        resources :posts, controller:"admin/posts", except: [:new, :create]
        patch "/posts/:id/unreport" => "admin/posts#unreport", as: "post_unreport"
        resources :levels, controller: "admin/levels", except: [:destroy, :show]
        resources :comments, controller: "admin/comments", only: [:index, :destroy]
        patch "/comments/:id/unreport" => "admin/comments#unreport", as: "comment_unreport"

    end

    devise_for :users, path: 'account', :controllers => { registrations: 'user_registrations' }

    resources :users, only: [:show, :edit, :update, :index]
    get "/users/:id/favorites" => "users#favorites", as: 'favorites'
    get "/users/:id/uploads" => "users#uploads", as: 'uploads'

    match "/404", :to => "errors#not_found", :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all

    %w(400 408 422 502 503 504).each do |code|
        match code, :to => "errors#error", :via => :all, :code => code
    end

end
