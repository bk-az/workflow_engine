require 'rails_helper'

# t.string   :title, null: false
# t.text     :description, null: false
# t.date     :start_date
# t.date     :due_date
# t.integer  :progress, default: 0
# t.integer  :priority, default: 0
# t.timestamps null: false

RSpec.describe Issue, type: :model do
  context 'validation tests' do
    it 'ensures title presence' do
      issue = Issue.new(description: 'description', start_date: '2017-07-23',
                        due_date: '2017-07-23', progress: '0',
                        priority: '2', company_id: '1', creator_id: '1',
                        assignee_id: '1', project_id: '1',
                        issue_type_id: '1', issue_state_id: '1').save
      expect(issue).to eq(false)
    end

    it 'ensures description presence' do
      issue = Issue.new(title: 'title', start_date: '2017-07-23',
                        due_date: '2017-07-23', progress: '0', priority: '2',
                        company_id: '1', creator_id: '1', assignee_id: '1',
                        project_id: '1', issue_type_id: '1',
                        issue_state_id: '1').save
      expect(issue).to eq(false)
    end

    it 'ensures start date presence' do
      issue = Issue.new(title: 'title', description: 'description',
                        due_date: '2017-07-23', progress: '0',
                        priority: '2', company_id: '1', creator_id: '1',
                        assignee_id: '1', project_id: '1', issue_type_id: '1',
                        issue_state_id: '1').save
      expect(issue).to eq(false)
    end

    it 'ensures due date presence' do
      issue = Issue.new(title: 'title', description: 'description',
                        start_date: '2017-07-23', progress: '0',
                        priority: '2', company_id: '1', creator_id: '1',
                        assignee_id: '1', project_id: '1', issue_type_id: '1',
                        issue_state_id: '1').save
      expect(issue).to eq(false)
    end

    it 'should save successfully' do
      issue = Issue.new(title: 'title', description: 'description',
                        start_date: '2017-07-23', due_date: '2017-07-23',
                        progress: '0', priority: '2', company_id: '1',
                        creator_id: '1', assignee_id: '1', project_id: '1',
                        issue_type_id: '1', issue_state_id: '1').save
      expect(issue).to eq(true)
    end
  end
end
