require 'cancan/matchers'
require 'rails_helper'

describe 'Issue' do
  before(:all) { @company = FactoryGirl.create(:company) }
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }
    context 'when is an admin' do
      let(:user) { create(:admin, company: @company) }
      it { should be_able_to(:manage, Issue) }
    end
    context 'when is a member' do
      let(:user) { create(:member, company: @company) }
      it { should_not be_able_to(:manage, Issue) }
      it { should be_able_to(:read, Issue) }
      it { should be_able_to(:filter, Issue) }
      it { should be_able_to(:create, Issue) }
      it { should be_able_to(:update, Issue) }
      it { should be_able_to(:destroy, Issue) }
      it { should_not be_able_to(:history, Issue) }
    end
  end
end
