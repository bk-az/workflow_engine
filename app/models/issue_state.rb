class IssueState < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: :company_id, case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: MAX_LENGTH_ISSUE_STATE })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :issue

  scope :issue_states_for_projects, ->(project) { project.issues.map(&:issue_state) }

  def self.safe_update(id, params)
    issue_state = IssueState.find(id)
    if params[:issue_id].nil?
      issue_state.update(params)
    else
      count = issue_state.issues.where.not(id: params[:issue_id]).count
      if count > 0
        issue_state.errors[:base] << "#{count} issue".pluralize(count) +
                                     ' found, preventing to change scope' \
                                     ' of this issue state'
      else
        issue_state.update(params)
      end
    end
    issue_state
  end

  def self.safe_destroy(id)
    issue_state = IssueState.find(id)
    count = issue_state.issues.count
    if count > 0
      issue_state.errors[:base] << "#{count} issue".pluralize(count) +
                                   ' using this state'
    else
      issue_state.destroy
    end
    issue_state
  end

  def self.load_issue_states(issue_id)
    if issue_id.nil?
      result = IssueState.all
    else
      result = IssueState.where(issue_id: [issue_id, nil])
    end
    result
  end
end
