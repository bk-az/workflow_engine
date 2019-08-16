class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string   :title, null: false
      t.text     :description, null: false
      t.date     :start_date
      t.date     :due_date
      t.integer  :progress, default: 0
      t.integer  :priority, default: 0
      t.timestamps null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
      t.integer :creator_id, null: false, index: true # creator id
      t.integer :assignee_id, index: true # assignee id
      t.integer :parent_issue_id, null: true, index: true
      t.integer :project_id, index: true
      t.integer :issue_state_id, null: false, index: true
      t.integer :issue_type_id, null: false, index: true
    end
  end
end
