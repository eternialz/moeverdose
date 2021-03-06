Rails.application.routes.draw do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    get 'home/show'

    # Homepage
    root 'application#home'

    # Posts
    get '/random' => 'posts#random', as: :random
    resources :posts, except: :create do
        resources :comments
    end
    post '/posts/new' => 'posts#create', as: 'create_post'
    post '/posts/:id/report' => 'posts#report_update', as: 'report_post'
    get '/posts/:id/report' => 'posts#report', as: 'new_report_post'
    patch '/posts/:id/dose/:dose' => 'posts#dose', as: 'post_dose'
    patch '/posts/:id/favorite' => 'posts#favorite', as: 'post_favorite'

    # Artists
    resources :authors

    # Tags
    resources :tags

    # Comments
    get '/posts/:post_id/comments/:comment_id/report' => 'comments#report', as: 'new_comment_report'
    post '/posts/:post_id/comments/:comment_id/report' => 'comments#report_update', as: 'comment_report'

    # Admin Section
    namespace :admin do
        root 'dashboard#index', as: 'dashboard'

        get 'stats' => 'dashboard#stats', as: 'stats'
        resources :users, controller: 'users', except: [:new, :create, :destroy]
        patch '/users/:id/unreport' => 'users#unreport', as: 'user_unreport'
        patch 'ban_user/:id', controller: 'users', action: :ban, as: 'user_ban'
        resources :news, controller: 'news'
        resources :posts, controller: 'posts', except: [:new, :create]
        patch '/posts/:id/unreport' => 'posts#unreport', as: 'post_unreport'
        resources :levels, controller: 'levels', except: [:destroy, :show]
        resources :comments, controller: 'comments', only: [:index, :destroy, :show]
        patch '/comments/:id/unreport' => 'comments#unreport', as: 'comment_unreport'
        resources :permissions_types, controller: 'permissions_types', except: [:edit, :update, :show]
    end

    # Users
    devise_for :users, path: 'account', controllers: { registrations: 'user_registrations' }

    resources :users, only: [:show, :edit, :update, :index]

    get '/users/:id/favorites' => 'users#favorites', as: 'user_favorites'
    get '/users/:id/uploads' => 'users#uploads', as: 'user_uploads'
    get '/users/:id/claims' => 'users#claims', as: 'user_claims'
    get '/users/:id/extract' => 'users#extract', as: 'extract_user'
    patch '/users/:id/delete' => 'users#delete', as: 'delete_user'
    get '/users/:id/report' => 'users#report', as: 'new_user_report'
    post '/users/:id/report' => 'users#report_update', as: 'user_report'

    # News
    resources :news, only: [:show]

    # Team
    resources :teams, controller: 'teams', only: [:index]

    # Claims
    resources :claims, controller: 'claims', only: [:show, :create, :new]
    patch 'claims/:id/decide' => 'claims#decide_status', as: 'decide_claim_status'
    patch 'claims/:id/cancel' => 'claims#cancel', as: 'cancel_claim'

    # Errors
    match '/404', to: 'errors#not_found', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all

    %w[400 408 422 502 503 504].each do |code|
        match code, to: 'errors#error', via: :all, code: code
    end

    # Static contents
    get '/wiki/:page' => 'static_pages#wiki', as: :wiki_static_page
    get '/:page' => 'static_pages#static', as: :static_page
end
