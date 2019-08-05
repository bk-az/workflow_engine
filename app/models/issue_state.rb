class IssueState < ActiveRecord::Base
  has_many :issues
  belongs_to :company
  belongs_to :issue

  scope :issue_states_for_projects, ->(project) { project.issues.map(&:issue_state) }
end
