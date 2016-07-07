Rails.application.routes.draw do
  
  root  'static_pages#home'
  match '/about', to: 'static_pages#about', via: 'get'
  
  match '/quests', to: 'quests#index', via: 'get'
  match '/checks', to: 'quests#check', via: 'post'
end