class ProjectMembership < ActiveRecord::Base
  not_multitenant

  belongs_to :project
  belongs_to :project_member, polymorphic: true
end
