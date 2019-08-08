require 'cancan/matchers'
require 'rails_helper'

describe 'IssueType' do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }
    context 'when is an admin' do
      let(:user) { create(:admin) }
      it { should be_able_to(:manage, IssueType) }
    end
    context 'when is a member' do
      let(:user) { create(:member) }
      it { should_not be_able_to(:manage, IssueType) }
      it { should_not be_able_to(:index, IssueType) }
      it { should_not be_able_to(:show, IssueType) }
      it { should_not be_able_to(:create, IssueType) }
      it { should_not be_able_to(:edit, IssueType) }
      it { should_not be_able_to(:update, IssueType) }
      it { should_not be_able_to(:destroy, IssueType) }
    end
  end
end
