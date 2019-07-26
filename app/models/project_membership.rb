class ProjectMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :project_member, polymorphic: true

  def self.search_for_membership(member_type, keyword, project)
    if member_type == 'Team'
      @members = Team.where('name like ?', "%#{sanitize_sql_like(keyword)}%").where.not(id: project.teams.ids)
    else # it is user
      @members = User.where('first_name like ?', "%#{sanitize_sql_like(keyword)}%").where.not(id: project.users.ids)
    end
    @members
  end
end
