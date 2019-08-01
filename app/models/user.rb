class User < ActiveRecord::Base
  belongs_to :company
  belongs_to :role
  has_many   :comments

  # Admin can create many issues
  has_many   :created_issues, foreign_key: 'creator_id', class_name: 'Issue'

  # A member can resolve many issues
  has_many   :assigned_issues, foreign_key: 'assignee_id', class_name: 'Issue'

  # A member can be a part of many teams
  has_many   :team_memberships
  has_many   :teams, through: :team_memberships

  # A member can have many projects
  has_many   :project_memberships, as: :project_member
  has_many   :projects, through: :project_memberships

  # A member can be a watcher of many issues
  has_many   :issue_watchers, as: :watcher
  has_many   :watching_issues, through: :issue_watchers, source: :issue

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # returns full name
  def name
    self[:first_name] + ' ' + self[:last_name]
  end

  def admin?
    role.name == 'Administrator'
  end

  def self.visible_projects(user)
    user.projects
  end
end
