require 'rails_helper'

RSpec.describe IssueType, type: :model do
  let(:issue_type) { create(:issue_type) }

  it 'should be valid' do
    expect(issue_type.valid?).to eq true
  end
  it 'name should be present' do
    issue_type.name = ''
    expect(issue_type.valid?).to eq false
  end
  it 'company_id should be present' do
    issue_type.company_id = ''
    expect(issue_type.valid?).to eq false
  end
  it 'name should be unique' do
    duplicate_issue_type = issue_type.dup
    duplicate_issue_type.name = issue_type.name.upcase
    expect(duplicate_issue_type.valid?).to eq false
  end
  it 'name should be unique in company scope' do
    duplicate_issue_type = issue_type.dup
    duplicate_issue_type.name = issue_type.name.upcase
    duplicate_issue_type.company_id = issue_type.company_id + 1
    expect(duplicate_issue_type.valid?).to eq true
  end
  it 'name should not be too long' do
    issue_type.name = 'a' * 21
    expect(issue_type.valid?).to eq false
  end
  it 'name should not be too short' do
    issue_type.name = 'a' * 2
    expect(issue_type.valid?).to eq false
  end
  it 'should load all issue types' do
    Company.current_id = 1
    expect(IssueType.load_issue_types(nil)).to eq IssueType.all
  end
  it 'should load all issue types of a project' do
    Company.current_id = 1
    expect(IssueType.load_issue_types(1)).to eq IssueType.where(project_id: [1, nil])
  end
end
