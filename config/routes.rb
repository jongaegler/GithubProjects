Rails.application.routes.draw do
  resources :projects

  root 'projects#index_with_count'
end
