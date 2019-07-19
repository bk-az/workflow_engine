class User < ActiveRecord::Base
  # This variable is kept in order keep track of whether the user is invited for not.

  # Validate name to compulsory and length ranging from 5 to 50.
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }

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
  has_many   :watching_issues, through: :issue_watchers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def send_invitation_email(company, role)
    UserMailer.invite(company, self, role).deliver
  end

  def company_id_valid?(company_id_provided)
    # Check if index of company_id_provided is nil or not.
    owned_companies_set = Company.select(:id).where(owner_id: id).collect
    if owned_companies_set.include? company_id_provided
      true
    else
      false
    end
  end

  def send_on_create_confirmation_instructions
    # CONFIRM USER ONLY WHEN HE IS NOT INVITED.
    send_confirmation_instructions unless is_invited_user?
  end
end
