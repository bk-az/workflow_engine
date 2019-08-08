require 'rails_helper'

RSpec.describe IssueState, type: :model do
  let(:issue_state) { create(:issue_state) }

  it 'should be valid' do
    expect(issue_state.valid?).to eq true
  end
  it 'name should be present' do
    issue_state.name = ''
    expect(issue_state.valid?).to eq false
  end
  it 'company_id should be present' do
    issue_state.company_id = ''
    expect(issue_state.valid?).to eq false
  end
  it 'name should be unique' do
    duplicate_issue_state = issue_state.dup
    duplicate_issue_state.name = issue_state.name.upcase
    expect(duplicate_issue_state.valid?).to eq false
  end
  it 'name should be unique in company scope' do
    duplicate_issue_state = issue_state.dup
    duplicate_issue_state.name = issue_state.name.upcase
    duplicate_issue_state.company_id = issue_state.company_id + 1
    expect(duplicate_issue_state.valid?).to eq true
  end
  it 'name should not be too long' do
    issue_state.name = 'a' * 21
    expect(issue_state.valid?).to eq false
  end
  it 'name should not be too short' do
    issue_state.name = 'a' * 2
    expect(issue_state.valid?).to eq false
  end
end
