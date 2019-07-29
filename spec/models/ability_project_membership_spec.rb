require 'cancan/matchers'
require 'rails_helper'
# ...
describe 'ProjectMembership' do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }
    context 'when is an admin' do
      let(:user) { create(:admin) }
      it { should be_able_to(:manage, ProjectMembership) }
    end
    context 'when is a member' do
      let(:user) { create(:member) }
      it { should_not be_able_to(:manage, ProjectMembership) }
      it { should_not be_able_to(:create, ProjectMembership) }
      it { should_not be_able_to(:destroy, ProjectMembership) }
    end
    context 'when is not a member of project' do
      let(:user) { create(:member) }
      it { should_not be_able_to(:index, ProjectMembership) }
    end
    context 'when is a member of current project' do
      before(:all) do
        @user = create(:member)
        @project = create(:project)
        @user.projects << @project
      end
      subject(:ability) { Ability.new(@user, project_id: @project.id) }
      it { should be_able_to(:index, ProjectMembership) }
    end
    context 'when is a member of a team which is a member of current project' do
      before(:all) do
        @user = create(:member)
        @team = create(:team)
        @project = create(:project)
        @team.projects << @project
        @team.users << @user
      end
      subject(:ability) { Ability.new(@user, project_id: @project.id) }
      it { should be_able_to(:index, ProjectMembership) }
    end
  end
end
