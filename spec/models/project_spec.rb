require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Multi Tenancy' do
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

  describe 'Project Model' do
    before(:all) do
      @company = create(:company)
      Company.current_id = @company.id
      @project = create(:project, company: @company)
      @admin = create(:admin, company: @company)
      @member = create(:member, company: @company)
    end
    it 'should have a valid factory' do
      expect(@project).to be_valid
    end

    it 'should be invalid without a title' do
      expect(FactoryGirl.build(:project, title: nil)).to_not be_valid
    end

    it 'should be invalid without a description' do
      expect(FactoryGirl.build(:project, description: nil)).to_not be_valid
    end

    it 'should have title with valid number of characters' do
      expect(@project.title).to have_at_most(100).characters
      expect(@project.title).to have_at_least(3).characters
    end

    it 'should have description with valid number of characters' do
      expect(@project.description).to have_at_most(1024).characters
      expect(@project.description).to have_at_least(3).characters
    end
  end
end
