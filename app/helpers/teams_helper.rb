module TeamsHelper
  def requested(team_id, user_id)
    TeamMembership.find_by(team_id: team_id, user_id: user_id, is_approved: false).present?
  end
  def already_joined_team(team_id, user_id)
    TeamMembership.find_by(team_id: team_id, user_id: user_id, is_approved: true).present?
  end
end
