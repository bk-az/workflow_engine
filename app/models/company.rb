class Company < ActiveRecord::Base
  not_multitenant

  before_save { subdomain.downcase! }
  after_create :create_issue_states, :create_issue_types

  validates :name, presence: true, length: { minimum: MIN_LENGTH, maximum: 50 }
  VALID_SUBDOMAIN_REGEX = /\A([a-z\d]+(-[a-z\d]+)*(_[a-z\d]+)*)\z/i.freeze
  validates :subdomain, presence: true, length: { minimum: MIN_LENGTH, maximum: 63 },
                        format: { with: VALID_SUBDOMAIN_REGEX },
                        uniqueness: { case_sensitive: false }

  belongs_to :owner, class_name: 'User' # Owner
  has_many   :users, dependent: :destroy
  has_many   :projects, dependent: :destroy
  has_many   :project_memberships, dependent: :destroy
  has_many   :teams, dependent: :destroy
  has_many   :team_memberships, dependent: :destroy
  has_many   :comments, dependent: :destroy
  has_many   :issues, dependent: :destroy
  has_many   :issue_watchers, dependent: :destroy
  has_many   :documents, dependent: :destroy
  has_many   :issue_types, dependent: :destroy
  has_many   :issue_states, dependent: :destroy

  def self.current_id=(id)
    Thread.current[:tenant_id] = id
  end

  def self.current_id
    Thread.current[:tenant_id]
  end

  def create_issue_states
    IssueState::DEFAULT_ISSUE_STATES.each { |name| issue_states.create!(name: name) }
    true
  end

  def create_issue_types
    IssueType::DEFAULT_ISSUE_TYPES.each { |name| issue_types.create!(name: name) }
    true
  end
end
