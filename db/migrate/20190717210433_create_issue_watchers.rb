class CreateIssueWatchers < ActiveRecord::Migration
  def change
    create_table :issue_watchers do |t|
      t.timestamps null: false

      # Foreign Keys
      t.integer :company_id, null: false, index: true
      t.references :watcher, polymorphic: true, index: true
      t.references :issue, index: true
    end
  end
end
