class CreateIssueWatchers < ActiveRecord::Migration
  def change
    create_table :issue_watchers, id: false do |t|
      t.timestamps null: false

      # Foreign Keys
      t.references :watcher, polymorphic: true, index: true
      t.references :issue, index: true
    end
  end
end
