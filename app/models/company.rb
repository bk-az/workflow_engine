class Company < ActiveRecord::Base
  after_save :create_issue_states, :create_issue_types

  belongs_to :owner, class_name: 'User' # Owner
  has_many   :users
  has_many   :projects
  has_many   :teams
  has_many   :comments
  has_many   :issues
  has_many   :documents
  has_many   :issue_types
  has_many   :issue_states

  def create_issue_states
    IssueState.new(name: 'Resolved', company_id: id).save!
    IssueState.new(name: 'Unresolved', company_id: id).save!
    true
  end

  def create_issue_types
    IssueType.new(name: 'Improvement', company_id: id).save!
    IssueType.new(name: 'New Feature', company_id: id).save!
    true
  end
end
