Rails.application.routes.draw do
  root  'static_pages#home'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/stats', to: 'static_pages#stats', via: 'get'
  match '/login', to: 'static_pages#login', via: 'post'

  match '/quests', to: 'quests#index', via: 'get'
  match '/checks', to: 'quests#check', via: 'post'

  match '/player', to: 'players#index', via: 'get'
  match '/player', to: 'players#destroy', via: 'delete'
end
