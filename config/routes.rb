Rails.application.routes.draw do
  root 'user_companies#find'

  resources :issues, only: :index do
    resources :comments, shallow: true
    get 'filter', on: :collection
  end

  resources :projects do
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
end
