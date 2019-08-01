class ProjectMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :project_member, polymorphic: true

  # scope :visible_projects, ->(user) { where(project_member_id: us.collect(&:id)) }
end
