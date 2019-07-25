class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :description
      t.string :domain_name, null: false
      t.timestamps null: false      
      # Foreign Keys
      t.integer :owner_id, null: false # owner id
    end
  end
end
