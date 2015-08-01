Rails.application.routes.draw do
  resources :skirmishes

  resources :songs

  root 'pages#home'

  get 'podcast.rss', to: 'songs#index', defaults: { format: 'xml' }

  get 'about', to: 'pages#about'
end
