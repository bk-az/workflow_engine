class AddIndexToProjectMemberships < ActiveRecord::Migration
  def change
    add_index :project_memberships, [:project_member_type, :project_member_id, :project_id], unique: true, name: 'index_project_memberships_on_project_member_and_project_id'
  end
end
