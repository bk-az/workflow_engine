class CreateProjectMemberships < ActiveRecord::Migration
  def change
    create_table :project_memberships, id: false do |t|
      t.timestamps null: false

      # Foreign Keys
      t.integer :project_member_id, index: true
      t.string  :project_member_type, index: true
      t.references :project, index: true
    end
  end
end
