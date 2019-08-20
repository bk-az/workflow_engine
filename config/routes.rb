Rails.application.routes.draw do
  resources :teams do
    collection do
      get 'add_membership'
      get 'approve_request'
    end

    member do
      delete 'remove_member'
    end
  end

  root 'user_companies#find'

  resources :issues, only: :index do
    get 'filter', on: :collection
    get 'history', on: :member
    resources :comments, shallow: true
    resources :documents, except: :destroy
  end

  resources :projects do
    resources :documents, except: :destroy
    resources :comments, shallow: true
    resources :issue_types, except: :destroy
    resources :project_memberships, only: %i[index create], as: 'members'
    resources :issues, only: [:new, :create, :show, :edit, :update, :destroy]
  end

  resources :documents do
    delete :destroy
  end

  resources :comments, only: [:edit, :update, :destroy]

  resources :issue_states do
    get :autocomplete_issue_title, on: :collection
  end

  resources :project_memberships, only: :destroy do
    collection do
      get 'search'
    end
  end

  resources :issue_types do
    get :autocomplete_project_title, on: :collection
  end

  get 'user_companies/find', to: 'user_companies#find'
  post 'user_companies/find', to: 'user_companies#find_user_by_email'
  get 'user_companies/show_companies', to: 'user_companies#show_companies', as: :show_companies

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  devise_scope :user do
    get 'users/sign_up/verify_subdomain_availability', to: 'users/registrations#verify_subdomain_availability'
  end

  get 'reports/issues', to: 'reports#issues', as: 'issues_report'
  get 'workplace', to: 'dashboard#index', as: 'dashboard'
  get 'dashboard/issues', to: 'dashboard#issues', as: 'dashboard_issues'

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
