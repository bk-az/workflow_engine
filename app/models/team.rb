# models/team.rb
class Team < ActiveRecord::Base
  belongs_to :company

  has_many :team_memberships
  has_many :users, through: :team_memberships

  has_many :project_memberships, as: :project_member
  has_many :projects, through: :project_memberships

  has_many :issue_watchers, as: :watcher
  has_many :watching_issues, through: :issue_watchers, source: :issue
end
