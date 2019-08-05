module ProjectMembershipsHelper
  def project_membership(project, project_member)
    ProjectMembership.find_by(project_id: project.id,
                              project_member_id: project_member.id,
                              project_member_type: project_member.class.name)
  end

  def project_member_type(project_member)
    project_member.class.name
  end

  def team?(project_member)
    project_member.class.name == 'Team'
  end
end
