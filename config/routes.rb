Rails.application.routes.draw do
  resources :songs

  root 'songs#index'

  get 'podcast.rss', to: 'songs#index', defaults: { format: 'xml' }
end
