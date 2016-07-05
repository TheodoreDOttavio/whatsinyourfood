Rails.application.routes.draw do
  
  root  'static_pages#home'
  
  match '/quests', to: 'quests#index', via: 'get'
  match '/checks', to: 'quests#check', via: 'post'
end