class ProjectMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :project_member, polymorphic: true

  def self.create_membership(type, id, project_id)
    begin
      member = get_member(type, id)
      project = Project.find(project_id)
      member.projects << project
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordNotUnique
      member = nil
    end
    [member, project]
  end

  def self.search_for_membership(member_type, keyword, project)
    if member_type == 'Team'
      members = Team.where('name like ?', "#{sanitize_sql_like(keyword)}%").where.not(id: project.teams.ids).limit(10).pluck(:name, :id)
    else # it is user
      members = User.where('email like ?', "#{sanitize_sql_like(keyword)}%").where.not(id: project.users.ids).limit(10).pluck(:email, :id)
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
               end
      member
    end
  end
end
