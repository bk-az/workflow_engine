module ProjectMembershipsHelper
  def project_membership(project, project_member, project_memberships)
    if project_memberships.present?
      project_membership = project_memberships.find do |membership|
        membership.project_id == project.id &&
          membership.project_member_id == project_member.id &&
          membership.project_member_type == project_member.class.name
      end
    else
      project_membership = ProjectMembership.find_by(
        project_id: project.id,
        project_member_type: project_member.class.name,
        project_member_id: project_member.id
      )
    end
    project_membership
  end

  def project_member_view_id(project_member)
    "\##{project_member.class.name}_#{project_member.id}"
  end

  def project_member_type(project_member)
    project_member.class.name
  end

  def team?(project_member)
    project_member.class.name == 'Team'
  end
end
