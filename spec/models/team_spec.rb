require 'rails_helper'

RSpec.describe Team, type: :model do
  before :all do
      # @team = FactoryGirl.create(:team)
      # binding.pry

      @company = create(:company)
      @admin = create(:admin, company: @company)
      @member = create(:member, company: @company)
      @team = create(:team, company: @company)
  end
  # before(:each) do
  #   # @request.host = "#{@company.subdomain}.lvh.me:3000"
  # end
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
end
