require 'rails_helper'

RSpec.describe Issue, type: :model do
  let(:issue) do
    @company = FactoryGirl.create(:company)
    @issue = FactoryGirl.create(:issue, company: @company)
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
