class AddIssuesCountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :issues_count, :integer
  end
end
