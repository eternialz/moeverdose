Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home/show'

  # Homepage
  root 'home#show'

  # Static contents
  get "/pages/:page" => "static#show"
  get "/pages/help/:page" => "static#help"
end
