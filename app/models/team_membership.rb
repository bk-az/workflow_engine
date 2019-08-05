class TeamMembership < ActiveRecord::Base
  not_multitenant

  belongs_to :user
  belongs_to :team
end
