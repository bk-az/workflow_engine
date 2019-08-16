class CreateIssueTypes < ActiveRecord::Migration
  def change
    create_table :issue_types do |t|
      t.string :name, null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
      t.integer :project_id, null: true, index: true
    end
  end
end
