module TeamsHelper
  def requested?(team_sequence_num, user_id)
    TeamMembership.find_by(team_id: team_sequence_num, user_id: user_id, is_approved: false).present?
  end
  def already_joined_team?(team_sequence_num, user_id)
    TeamMembership.find_by(team_id: team_sequence_num, user_id: user_id, is_approved: true).present?
  end

  def is_team_admin(is_admin)
    is_admin ? "Yes" : "No" 
  end
end