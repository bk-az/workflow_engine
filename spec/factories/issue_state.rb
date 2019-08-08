require 'faker'

FactoryGirl.define do
  factory :issue_state do |f|
    f.name { Faker::Name.first_name }
    company_id 1
  end
end
