class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :path, null: false
      t.timestamps null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
      t.integer :issue_id, null: false, index: true
    end
  end
end
