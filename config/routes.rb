Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  
  get 'members/privileges' => 'members#privileges', as: :members_privileges
  get 'members/privileges/:id' => 'members#privileges_show', as: :members_privileges_show
  get 'members/:id/setpassword' => 'members#show_change_password_form', as: :members_set_password
  put 'members/setpassword' => 'members#change_password', as: :members_set_password_change

  resources :members
end
