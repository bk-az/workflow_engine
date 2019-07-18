class ProjectMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :project_member, polymorphic: true
end
