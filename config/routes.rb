Rails.application.routes.draw do
  devise_for :users

  resources :issues do
    get 'filter', on: :collection
  end

  devise_scope :user do
    get 'signout', to: 'devise/sessions#destroy'
  end

  resources :issue_watchers do
    collection do
      post 'create_watcher'
      post 'destroy_watcher'
      get  'search_watcher_to_add'
      get  'search_watcher_to_destroy'
    end
  end
end
