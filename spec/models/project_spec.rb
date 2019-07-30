require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project1_title)      { 'project1_title' }
  let(:project2_title)      { 'project2_title' }
  let(:company1_subdomain)  { 'company1_subdomain' }
  let(:company2_subdomain)  { 'company2_subdomain' }

  let(:project1) { Project.where(title: project1_title) }
  let(:project2) { Project.where(title: project2_title) }

  let(:company1) { Company.find_by_subdomain(company1_subdomain) }
  let(:company2) { Company.find_by_subdomain(company2_subdomain) }

  before(:all) do
    c1 = Company.create!(name: 'Company1',
                         description: 'description',
                         subdomain: 'company1_subdomain',
                         owner_id: 1)
    c1.projects.create!(title: 'project1_title', description: 'Lorem ipsum')

    c2 = Company.create!(name: 'Company2',
                         description: 'description',
                         subdomain: 'company2_subdomain',
                         owner_id: 1)
    c2.projects.create!(title: 'project2_title', description: 'Lorem ipsum')
  end

  after(:all) do
    Company.find_by_subdomain('company1_subdomain').destroy
    Company.find_by_subdomain('company2_subdomain').destroy
  end

  describe 'Multi Tenancy' do
    context 'query with no company set' do
      it 'should return empty relation' do
        expect(Project.all).to be_empty
      end
    end

    context 'query in company 1' do
      it "should return only company1's projects" do
        Company.current_id = company1.id
        expect(Project.all.ids).to eq project1.ids
      end
    end

    context 'query in company 2' do
      it "should return only company2's projects" do
        Company.current_id = company2.id
        expect(Project.all.ids).to eq project2.ids
      end
    end
  end
end
