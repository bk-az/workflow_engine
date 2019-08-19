class ProjectMembership < ActiveRecord::Base
  not_multitenant

  validates :project_id, :project_member_id, :project_member_type, presence: true

  scope :user_memberships, -> { where(project_member_type: 'User') }
  scope :team_memberships, -> { where(project_member_type: 'Team') }

  belongs_to :project
  belongs_to :project_member, polymorphic: true

  # class methods
  def self.user_projects(user, project_id)
    return [] if project_id.nil? || user.nil?

    ProjectMembership.where('company_id = ? and project_id = ? and ' \
      '(project_member_id = ? and project_member_type = "User") or ' \
      '(project_member_id in (?) and project_member_type = "Team")',
                            Company.current_id,
                            project_id,
                            user.id,
                            user.teams.ids).ids
  end

  def self.autocomplete_member(member_type, keyword, project)
    if member_type == 'Team'
      search_results = Team.where('LOWER(name) like ?', "#{sanitize_sql_like(keyword)}%").where.not(id: project.teams.ids).limit(10).pluck(:name, :id)
    else # it is user
      search_results = User.where('LOWER(email) like ?', "#{sanitize_sql_like(keyword)}%").where.not(id: project.users.ids).limit(10).pluck(:email, :id)
    end
    search_results
  end
end
