Rails.application.routes.draw do
  get '/play' => 'game#index'
  get '/play/new' => 'game#play'
  get '/play/video' => 'game#video'
  get '/play/validate' => 'game#validate'
  get '/leaderboard' => 'game#leaderboard'

  root :to => 'home#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', :as => :logout
  get '/login' => 'sessions#new', :as => :login
end
