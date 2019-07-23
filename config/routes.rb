Rails.application.routes.draw do
  default_url_options host: 'localhost:3000'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  get 'users/invite' => 'users_custom#invite', as: :new_user_invite
  post 'users/invite' => 'users_custom#invite_create', as: :new_user_invite_create
  get 'users/privileges' => 'users_custom#privileges', as: :users_privileges
  post 'users/privileges/edit' => 'users_custom#privileges_edit', as: :users_privileges_edit
  post 'users/privileges/edit/submit' => 'users_custom#privileges_edit_submit', as: :users_privileges_edit_submit
end
