require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:project)).to be_valid
  end

  it 'is invalid without a title' do
    expect(FactoryGirl.build(:project, title: nil)).to_not be_valid
  end

  it 'is invalid without a description' do
    expect(FactoryGirl.build(:project, description: nil)).to_not be_valid
  end
end
