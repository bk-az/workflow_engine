# models/team.rb
class Team < ActiveRecord::Base
  sequenceid :company, :teams

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  belongs_to :company

  has_many :team_memberships
  has_many :users, through: :team_memberships

  has_many :project_memberships, as: :project_member
  has_many :projects, through: :project_memberships

  has_many :issue_watchers, as: :watcher
  has_many :watching_issues, through: :issue_watchers, source: :issue

  def member_and_team_memberships
    @team_memberships = TeamMembership.where(team_id: id)
    already_present_member_ids = @team_memberships.pluck(:user_id)
    @all_members = User.where.not(id: already_present_member_ids).select(:id, :first_name)
    [@team_memberships, @all_members]
  end
end
