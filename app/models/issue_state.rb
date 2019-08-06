class IssueState < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: [:issue_id, :company_id], case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: MAX_LENGTH_ISSUE_STATE })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :issue

  scope :issue_specific_states, ->(issue_id) { where(issue_id: [issue_id, nil]) }
  scope :issue_states_for_projects, ->(project) { project.issues.map(&:issue_state) }

  def safe_update?(params)
    result = true
    if params[:issue_id].nil?
      update(params)
    else
      count = issues.where.not(id: params[:issue_id]).count
      if count > 0
        result = false
        errors[:base] << "#{count} issue".pluralize(count) +
                         ' found, preventing to change scope' \
                         ' of this issue state'
      else
        update(params)
      end
    end
    result
  end

  def safe_destroy?
    result = true
    count = issues.count
    if count > 0
      result = false
      errors[:base] << "#{count} issue".pluralize(count) +
                       ' using this state'
    else
      destroy
    end
    result
  end
end
