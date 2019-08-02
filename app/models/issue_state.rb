class IssueState < ActiveRecord::Base
  has_many :issues
  belongs_to :company
  belongs_to :issue

  def self.load_issue_states(issue_id)
    if issue_id.nil?
      result = IssueState.all
    else
      result = IssueState.where(issue_id: [issue_id, nil])
    end
    result
  end
end
