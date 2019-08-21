require 'rails_helper'
require 'database_cleaner'

  

RSpec.describe Team, type: :model do
  before :all do
      @company = create(:company)
      @admin = create(:admin, company: @company)
      @member = create(:member, company: @company)
      @team = create(:team, company: @company)
  end
  context 'validation tests for attributes presence' do
    it 'ensures name presence' do
      expect(@team.valid?).to eq true
    end
    it 'ensures name absence' do
      @team.name = ''
      expect(@team.valid?).to eq false
    end
    it 'title should not be too long' do
      @team.name = 'a' * 101
      expect(@team.valid?).to eq false
    end
    it 'name should not be too short' do
      @team.name = 'a' * 2
      expect(@team.valid?).to eq false
    end
  end

  context 'it validates functions' do
    it 'validates correct users and team memberships are returned for search function' do
      @team_memberships, @all_members = @team.member_and_team_memberships
      team_memberships = TeamMembership.where(team_id: @team.id)
      already_present_member_ids = team_memberships.pluck(:user_id)
      all_members = User.where.not(id: already_present_member_ids).select(:id, :first_name)
      expect(@team_memberships).to eq team_memberships
      expect(@all_members).to eq all_members
    end
    it 'validates correct pending requests are returned' do
      pending_requests = TeamMembership.where(team_id: @team.id, is_approved: false)
      @pendings = @team.pending_requests
      expect(@pendings).to eq pending_requests
    end
  end
end
