Rails.application.routes.draw do
  resources :skirmishes, only: [:index]

  resources :songs, only: [:index]

  root 'pages#home'

  get 'podcast.rss', to: 'songs#index', defaults: { format: 'xml' }

  get 'about', to: 'pages#about'
end
