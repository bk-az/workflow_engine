# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, options = {})
    if user.present?
      if user.admin?
        can :manage, :all
      elsif !options[:project_id].nil?
        sql = "SELECT `project_memberships`.`id` FROM `project_memberships` WHERE `project_memberships`.`project_id` = #{options[:project_id]} AND (`project_memberships`.`project_member_id` = #{user.id} AND `project_memberships`.`project_member_type` = 'User') OR (`project_memberships`.`project_member_type` = 'Team' AND `project_memberships`.`project_member_id` IN (SELECT `teams`.`id` FROM `teams` INNER JOIN `team_memberships` ON `teams`.`id` = `team_memberships`.`team_id` WHERE `team_memberships`.`user_id` = #{user.id}))"
        can :index, ProjectMembership if ProjectMembership.find_by_sql(sql).present?
      end
    end
  end
end
