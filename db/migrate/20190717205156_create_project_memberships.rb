class CreateProjectMemberships < ActiveRecord::Migration
  def change
    create_table :project_memberships do |t|
      t.timestamps null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
      t.references :project_member, polymorphic: true, null: false, index: { name: 'index_project_memberships_on_project_member_type_and_id' }
      t.references :project, null: false, index: true
    end
  end
end