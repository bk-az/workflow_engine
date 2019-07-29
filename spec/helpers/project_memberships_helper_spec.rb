require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ProjectMembershipsHelper. For example:
#
# describe ProjectMembershipsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ProjectMembershipsHelper, type: :helper do
  before(:all) do
    @project_membership = create(:project_membership)
    @project = @project_membership.project
    @project_member = @project_membership.project_member
  end

  let(:project) { create(:project) }
  let(:user)    { create(:user) }
  let(:team)    { create(:team) }

  it 'should return nil if membership not exists' do
    expect(project_membership(project, user)).to eq nil
  end
  it 'should return project-membership if membership exists' do
    expect(project_membership(@project, @project_member)).to eq @project_membership
  end
end
