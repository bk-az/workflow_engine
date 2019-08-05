require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:all) { @comment = FactoryGirl.create(:comment) }
  it 'should have a valid factory' do
    expect(@comment).to be_valid
  end

  it 'should be invalid without a content' do
    expect(FactoryGirl.build(:comment, content: nil)).to_not be_valid
  end

  it 'should have content with valid number of characters' do
    expect(@comment.content).to have_at_most(1024).characters
    expect(@comment.content).to have_at_least(3).characters
  end
end
