require 'rails_helper'
require 'spec_helper'
require 'cancan/matchers'

RSpec.describe 'Ability' do
  describe 'as a member' do
    before(:each) do
      @user = create(:member)
      @ability = Ability.new(@user)
      @project = create(:project)
      @user.projects << @project
    end
    let(:project2) { create(:project) }

    it "can go to :index and :show of the project it's part of" do
      expect(@ability).to be_able_to(:index, @project)
      expect(@ability).to be_able_to(:show, @project)
    end
    it 'cannot create any project' do
      expect(@ability).to_not be_able_to(:create, Project)
    end
    it 'cannot edit any project' do
      expect(@ability).to_not be_able_to(:update, Project)
    end
    it 'cannot delete any project' do
      expect(@ability).to_not be_able_to(:destroy, Project)
    end
    it "cannot go to :index or :show of the project it's not part of" do
      expect(@ability).to_not be_able_to(:index, project2)
      expect(@ability).to_not be_able_to(:show, project2)
    end
  end

  describe 'as an admin' do
    let(:user) { create(:admin) }
    subject(:ability) { Ability.new(user) }
    let(:project) { create(:project) }

    %i[create read update destroy].each do |role|
      it { is_expected.to be_able_to(role, project) }
    end
  end
end
