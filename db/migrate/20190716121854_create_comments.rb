class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.timestamps null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
      t.integer :user_id, index: true
      t.references :commentable, polymorphic: true, index: true
    end
  end
end
