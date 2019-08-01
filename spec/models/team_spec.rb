require 'rails_helper'

RSpec.describe Team, type: :model do
  before :all do
      @team = FactoryGirl.create(:team)
  end
  context 'validation tests for attributes presence' do
    it 'ensures name presence' do
      expect(@team.valid?).to eq true
    end
    it 'ensures name absence' do
      @team.name = ''
      expect(@team.valid?).to eq false
    end
  end
end
