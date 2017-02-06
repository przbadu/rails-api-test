Rails.application.routes.draw do
  post 'login' => 'user_token#create'

  resources :users
end
