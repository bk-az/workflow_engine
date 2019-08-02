require 'faker'

FactoryGirl.define do
  factory :issue do |f|
    f.company_id 1
    f.title { Faker::Company.buzzword }
    f.description { Faker::Lorem.paragraph }
    creator_id 1
    assignee_id 1
    issue_state_id 1
    issue_type_id 1
  end
end
