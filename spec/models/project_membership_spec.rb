require 'rails_helper'

RSpec.describe ProjectMembership, type: :model do
  before(:all) do
    @company = create(:company)
    Company.current_id = @company.id
  end

  let(:project) { create(:project, company: @company) }
  let(:user)    { create(:user, company: @company) }
  let(:team)    { create(:team, company: @company) }
  let(:user_search_keyword) { user.email }
  let(:team_search_keyword) { team.name }

  let(:user_membership_params) do
    { project_id: project.id,
      project_member_id: user.id,
      project_member_type: user.class.name }
  end
  let(:team_membership_params) do
    { project_id: project.id,
      project_member_id: team.id,
      project_member_type: team.class.name }
  end

  context 'Searching' do
    it 'should return team names and ids' do
      team_names_and_ids = ProjectMembership.autocomplete_member(team.class.name, team_search_keyword, project)
      expect(
        team_names_and_ids.flatten.include?(team.name)
      ).to eq true
    end
    it 'should return user emails and ids' do
      user_emails_and_ids = ProjectMembership.autocomplete_member(user.class.name, user_search_keyword, project)
      expect(
        user_emails_and_ids.flatten.include?(user.email)
      ).to eq true
    end
    it 'should not return user email if already a member' do
      # create a membership
      ProjectMembership.create(user_membership_params)
      # search users
      user_emails_and_ids = ProjectMembership.autocomplete_member(user.class.name, user_search_keyword, project)
      expect(
        user_emails_and_ids.flatten.include?(user.email)
      ).to eq false
    end
    it 'should not return team name if already a member' do
      # create a membership
      ProjectMembership.create(team_membership_params)
      # search teams
      team_names_and_ids = ProjectMembership.autocomplete_member(team.class.name, team_search_keyword, project)
      expect(
        team_names_and_ids.flatten.include?(team.name)
      ).to eq false
    end
  end
end
