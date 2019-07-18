class CreateIssueStates < ActiveRecord::Migration
  def change
    create_table :issue_states do |t|
      t.string :name, null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
      t.integer :issue_id, null: true, index: true
    end
  end
end
