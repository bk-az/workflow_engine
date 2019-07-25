module MembershipsHelper
  def project_membership(project, member)
    ProjectMembership.find_by!(project_id: project.id,
                               project_member_id: member.id,
                               project_member_type: member.class.name)
  end
end
