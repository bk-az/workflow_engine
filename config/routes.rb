Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  get 'users/invite' => 'users_custom#invite', as: :new_user_invite
  post 'users/invite' => 'users_custom#invite_create', as: :new_user_invite_create
end
