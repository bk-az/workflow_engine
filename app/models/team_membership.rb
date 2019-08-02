class TeamMembership < ActiveRecord::Base
  validates :is_team_admin, inclusion: { in: [true, false] }
  validates :is_approved, inclusion: { in: [true, false] }
  validates :user_id, presence: true
  validates :team_id, presence: true
  belongs_to :user
  belongs_to :team
end
