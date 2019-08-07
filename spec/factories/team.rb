require 'faker'

FactoryGirl.define do
  factory :team do |f|
    f.company_id 1
    f.name { Faker::Team.name }
  end
end
