require 'rails_helper'

RSpec.describe TeamMembership, type: :model do
  before :all do
      @team_membership = FactoryGirl.create(:team_membership)
  end
  context 'validation tests for attributes presence' do
    it 'ensures is_team_admin, team_id, user_id presence' do
      expect(@team_membership.valid?).to eq true
    end
    it 'ensures is_team_admin absence' do
      @team_membership.is_team_admin = ''
      expect(@team_membership.valid?).to eq false
    end
    it 'checks team_id absence' do
      @team_membership.team_id= ''
      expect(@team_membership.valid?).to eq false
    end
    it 'checks user_id absence' do
      @team_membership.user_id= ''
      expect(@team_membership.valid?).to eq false
    end
  end
end
