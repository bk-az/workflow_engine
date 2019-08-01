class Project < ActiveRecord::Base
  belongs_to :company
  has_many   :issues
  has_many   :issue_types

  has_many :comments, as: :commentable

  # Polymorphic Team/User
  has_many :project_memberships
  # has_many :project_members, through: :project_memberships
  has_many :teams, through: :project_memberships, source: :project_member,
                   source_type: 'Team'
  has_many :users, through: :project_memberships, source: :project_member,
                   source_type: 'User'
end
