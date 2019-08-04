require 'faker'

FactoryGirl.define do
  factory :issue_state do |f|
    f.name { Faker::Company.buzzword }
    company_id 1
  end
end
