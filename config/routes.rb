Rails.application.routes.draw do
    get 'home/show'

    # Homepage
    root 'application#home'

    # Posts
    get "/random" => "posts#random", as: :random
    resources :posts, except: :create do
        resources :comments
    end
    post '/posts/new' => "posts#create", as: 'create_post'
    get "/posts/md5/:md5" => "posts#md5", as: 'md5_check_post'
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
    namespace :admin do
        root 'dashboard#index', as: 'dashboard'

        get "stats" => "dashboard#stats", as: 'stats'
        resources :users, controller: "users", except: [:new, :create, :show]
        patch 'ban_user/:id', controller: "users", action: :ban, as: 'user_ban'
        resources :news, controller: "news"
        resources :posts, controller:"posts", except: [:new, :create]
        patch "/posts/:id/unreport" => "posts#unreport", as: "post_unreport"
        resources :levels, controller: "levels", except: [:destroy, :show]
        resources :comments, controller: "comments", only: [:index, :destroy]
        patch "/comments/:id/unreport" => "comments#unreport", as: "comment_unreport"
    end

    devise_for :users, path: 'account', :controllers => { registrations: 'user_registrations' }

    resources :users, only: [:show, :edit, :update, :index]
    get "/users/:id/favorites" => "users#favorites", as: 'favorites'
    get "/users/:id/uploads" => "users#uploads", as: 'uploads'

    resources :news, only: [:show]

    resources :teams, controller: "teams", only: [:index]

    match "/404", :to => "errors#not_found", :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all

    %w(400 408 422 502 503 504).each do |code|
        match code, :to => "errors#error", :via => :all, :code => code
    end

    # Static contents
    get "/wiki/:page" => "static_pages#wiki", as: :wiki_static_page
    get "/:page" => "static_pages#static", as: :static_page
end
