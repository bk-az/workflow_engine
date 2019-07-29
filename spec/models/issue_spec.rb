require 'rails_helper'

# t.string   :title, null: false
# t.text     :description, null: false
# t.date     :start_date
# t.date     :due_date
# t.integer  :progress, default: 0
# t.integer  :priority, default: 0
# t.timestamps null: false

RSpec.describe Issue, type: :model do
  let(:title)           { 'title' }
  let(:description)     { 'description' }
  let(:start_date)      { '2017-07-23' }
  let(:due_date)        { '2017-07-23' }
  let(:progress)        { '0' }
  let(:priority)        { '2' }
  let(:company_id)      { '1' }
  let(:creator_id)      { '1' }
  let(:assignee_id)     { '1' }
  let(:project_id)      { '1' }
  let(:issue_type_id)   { '1' }
  let(:issue_state_id)  { '1' }

  let(:issue) do
    Issue.new(title: title, description: description,
              start_date: start_date, due_date: due_date,
              progress: progress, priority: priority, company_id: company_id,
              creator_id: creator_id, assignee_id: assignee_id,
              project_id: project_id, issue_type_id: issue_type_id,
              issue_state_id: issue_state_id)
  end
  context 'validation tests' do
    it 'ensures title presence' do
      issue.title = ''
      expect(issue.valid?).to eq false
    end

    it 'ensures description min length' do
      issue.description = ''
      expect(issue.valid?).to eq false
    end

    it 'ensures start date presence' do
      issue.start_date = ''
      expect(issue.valid?).to eq true
    end

    it 'ensures due date presence' do
      issue.due_date = ''
      expect(issue.valid?).to eq true
    end

    it 'should save successfully' do
      expect(issue.valid?).to eq true
    end
  end
end
