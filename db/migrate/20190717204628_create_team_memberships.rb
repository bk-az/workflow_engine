class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships, id: false do |t|
      t.boolean :is_team_admin, default: false
      t.boolean :is_approved, default: false
      t.timestamps null: false

      # Foreign Keys
      t.references :team, index: true
      t.references :user, index: true
    end
  end
end
