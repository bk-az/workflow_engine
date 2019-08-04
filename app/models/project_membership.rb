class ProjectMembership < ActiveRecord::Base
  not_multitenant

  belongs_to :project
  belongs_to :project_member, polymorphic: true

  def self.user_projects(user, project_id)
    return [] if project_id.nil? || user.nil?

    ProjectMembership.where('project_id = ? and ' \
      '(project_member_id = ? and project_member_type = "User") or ' \
      '(project_member_id in (?) and project_member_type = "Team")',
                            project_id,
                            user.id,
                            user.teams.ids).ids
  end

  def self.create_membership(params)
    result = true
    begin
      member = get_member(params[:project_member_type], params[:project_member_id])
      project = Project.find(params[:project_id])
      member.projects << project
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordNotUnique
      result = false
    end
    [result, member, project]
  end

  def self.autocomplete_member(member_type, keyword, project)
    if member_type == 'Team'
      members = Team.where('LOWER(name) like ?', "#{sanitize_sql_like(keyword)}%").where.not(id: project.teams.ids).limit(10).pluck(:name, :id)
    else # it is user
      members = User.where('LOWER(email) like ?', "#{sanitize_sql_like(keyword)}%").where.not(id: project.users.ids).limit(10).pluck(:email, :id)
    end
    members
  end

  class << self
    private

    def get_member(type, id)
      member = if type == 'User'
                 User.find(id)
               elsif type == 'Team'
                 Team.find(id)
               else
                 raise ActiveRecord::RecordNotFound
               end
      member
    end
  end
end
