module TeamsHelper
  def requested(team_id, user_id)
    TeamMembership.find_by('team_id = ? and user_id= ? and is_approved= ?', team_id, user_id, false).present?
  end
end
