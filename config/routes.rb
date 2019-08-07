Rails.application.routes.draw do

  resources :issues, only: :index do

    resources :comments, shallow: true
    get 'filter', on: :collection
    resources :documents
  end

  devise_scope :user do
    get 'signout', to: 'devise/sessions#destroy'
  end

  resources :projects do
    resources :documents
    resources :comments, shallow: true
    resources :issues, only: [:new, :create, :show, :edit, :update, :destroy]
  end

  resources :comments, only: [:edit, :update, :destroy]


  get 'user_companies/find', to: 'user_companies#find'
  post 'user_companies/find', to: 'user_companies#find_user_by_email'
  get 'user_companies/show_companies', to: 'user_companies#show_companies', as: :show_companies

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resources :members do
    member do
      get 'privileges', action: 'privileges_show'
      get 'change_password_form', action: 'show_change_password_form'
      put 'change_password', action: 'change_password'
    end
    collection do
      get 'privileges'
    end
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
