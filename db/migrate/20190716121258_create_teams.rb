class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.timestamps null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
    end
  end
end
