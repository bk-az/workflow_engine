class User < ActiveRecord::Base
  attr_accessor :skip_invitation_email

  # Scopes
  scope :active, -> { where(is_active: true) }

  # Callbacks
  # Runs only when is_active attribute is changed.
  before_save :check_for_issues, :check_for_ownership_of_company, if: :is_active_changed?

  # Set Validators.
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role_id, presence: true
  validates :email, uniqueness: {scope: :company_id}
  belongs_to :company
  belongs_to :role
  has_many   :comments

  accepts_nested_attributes_for :company
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
  has_many   :watching_issues, through: :issue_watchers

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
  :recoverable, :rememberable, :trackable, :validatable

  # To override devise email validation process.
  def email_required?
    false
  end

  def email_changed?
    false
  end

  # For ActiveRecord 5.1+
  def will_save_change_to_email?
    false
  end
  # -------------

  def send_invitation_email(company, role)
    UserMailer.invite(company, self, role).deliver unless skip_invitation_email
  end

  def send_on_create_confirmation_instructions
    # CONFIRM USER ONLY WHEN HE IS NOT INVITED.
    send_confirmation_instructions unless has_changed_sys_generated_password?
  end

  def check_for_issues
    if assigned_issues.any?
      errors[:base] << I18n.t('.models.user.check_for_issues.error_message')
      return false
    end
    true
  end

  def check_for_ownership_of_company
    # Check if the company to which current user belongs has owner = user himself.
    if company.owner_id == id
      errors[:base] << I18n.t('.models.user.check_for_ownership_of_company.error_message')
      return false
    end
    true
  end

  def self.find_for_authentication(warden_conditions)
    where(:email => warden_conditions[:email]).first
  end
end
