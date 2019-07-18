class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.timestamps null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
    end
  end
end
