Rails.application.routes.draw do
  resources :quests
  post 'toggle', to: 'quests#toggle'

  root to: "quests#index"

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
