require 'faker'

FactoryGirl.define do
  factory :project_membership do
    project
    association :project_member, factory: :user
  end
end
