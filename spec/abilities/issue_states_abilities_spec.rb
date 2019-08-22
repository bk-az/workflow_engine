require 'cancan/matchers'
require 'rails_helper'

describe 'IssueState' do
  before(:all) { @company = create(:company) }
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }
    context 'when is an admin' do
      let(:user) { create(:admin) }
      it { should be_able_to(:manage, IssueState) }
    end
    context 'when is a member' do
      let(:user) { create(:member) }
      before(:each) { Company.current_id = @company.id }
      it { should_not be_able_to(:manage, IssueState) }
      it { should_not be_able_to(:index, IssueState) }
      it { should_not be_able_to(:show, IssueState) }
      it { should_not be_able_to(:create, IssueState) }
      it { should_not be_able_to(:edit, IssueState) }
      it { should_not be_able_to(:update, IssueState) }
      it { should_not be_able_to(:destroy, IssueState) }
    end
  end
end
