require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:all) { @project = FactoryGirl.create(:project) }
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
