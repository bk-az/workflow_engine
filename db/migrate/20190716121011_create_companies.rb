class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :description
      t.string :subdomain, null: false, unique: true, index: true
      t.timestamps null: false
      
      # Foreign Keys
      t.integer :owner_id, null: false # owner id
    end
  end
end
