require 'rails_helper'

RSpec.describe ProjectMembership, type: :model do
  before(:all) do
    @company = create(:company)
    Company.current_id = @company.id
  end

  let(:project) { create(:project, company: @company) }
  let(:user)    { create(:user, company: @company) }
  let(:team)    { create(:team, company: @company) }
  let(:user_search_keyword) { user.email.first }
  let(:team_search_keyword) { team.name.first }

  context 'Create Project-Membership' do
    it 'should create a project-user-membership' do
      ProjectMembership.create_membership(user.class.name, user.id, project.id)
      expect(user.projects.include?(project)).to eq true
    end
    it 'should create a project-team-membership' do
      ProjectMembership.create_membership(team.class.name, team.id, project.id)
      expect(team.projects.include?(project)).to eq true
    end

    it 'should create a project-user-membership and return user and project' do
      expect(
        ProjectMembership.create_membership(user.class.name, user.id, project.id)
      ).to eq [user, project]
    end
    it 'should create a project-team-membership and return team and project' do
      expect(
        ProjectMembership.create_membership(team.class.name, team.id, project.id)
      ).to eq [team, project]
    end
  end
  context 'Searching' do
    it 'should return team names and ids' do
      team_names_and_ids = ProjectMembership.search_for_membership(team.class.name, team_search_keyword, project)
      expect(
        team_names_and_ids.flatten.include?(team.name)
      ).to eq true
    end
    it 'should return user emails and ids' do
      user_emails_and_ids = ProjectMembership.search_for_membership(user.class.name, user_search_keyword, project)
      expect(
        user_emails_and_ids.flatten.include?(user.email)
      ).to eq true
    end
    it 'should not return user email if already a member' do
      # create a membership
      ProjectMembership.create_membership(user.class.name, user.id, project.id)
      # search users
      user_emails_and_ids = ProjectMembership.search_for_membership(user.class.name, user_search_keyword, project)
      expect(
        user_emails_and_ids.flatten.include?(user.email)
      ).to eq false
    end
    it 'should not return team name if already a member' do
      # create a membership
      ProjectMembership.create_membership(team.class.name, team.id, project.id)
      # search teams
      team_names_and_ids = ProjectMembership.search_for_membership(team.class.name, team_search_keyword, project)
      expect(
        team_names_and_ids.flatten.include?(team.name)
      ).to eq false
    end
  end
end
