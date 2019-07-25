class User < ActiveRecord::Base
  # Callbacks
  before_destroy :check_for_issues, :check_for_being_admin

  # Set Validators.
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role_id, presence: true

  # belongs_to :owned_company, foreign_key: 'owner_id', class_name: 'Company'
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

  def send_invitation_email(company, role)
    UserMailer.invite(company, self, role).deliver
  end

  def send_on_create_confirmation_instructions
    # CONFIRM USER ONLY WHEN HE IS NOT INVITED.
    send_confirmation_instructions unless is_invited_user?
  end

  def check_for_issues
    if assigned_issues.empty?
      true
    else
      errors[:base] << 'Cannot delete this Member as there are Issues assigned to him/her.'
      false
    end
  end

  def check_for_being_admin
    if role.name == 'Administrator'
      errors[:base] << 'Cannot delete this Member as he/she is admin.'
      false
    else
      true
    end
  end
end
