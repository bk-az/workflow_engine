Rails.application.routes.draw do
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
  get 'members' => 'members#index', as: :members
  get 'members/:id' => 'members#show', as: :member_show
  get 'members/edit/:id' => 'members#edit', as: :member_edit
  put 'members/edit/' => 'members#update', as: :member_update
  delete 'members/delete/:id' => 'members#delete', as: :member_delete
end
