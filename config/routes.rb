Rails.application.routes.draw do
  default_url_options host: 'localhost:3000'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  get 'members/invite' => 'members#invite', as: :member_invite
  post 'members/invite' => 'members#invite_create', as: :member_invite_create
  get 'members/privileges' => 'members#privileges', as: :members_privileges
  get 'members/privileges/:id' => 'members#privileges_show', as: :members_privileges_show
  put 'members/privileges/edit' => 'members#privileges_update', as: :members_privileges_update
end
