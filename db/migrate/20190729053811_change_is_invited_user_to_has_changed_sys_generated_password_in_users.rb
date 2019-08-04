class ChangeIsInvitedUserToHasChangedSysGeneratedPasswordInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :is_invited_user, :has_changed_sys_generated_password
  end
end
