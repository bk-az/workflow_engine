class ChangeDefaultValueToTrueHasChangedSysGeneratedPass < ActiveRecord::Migration
  def change
    change_column :users, :has_changed_sys_generated_password, :boolean, default: true
  end
end
