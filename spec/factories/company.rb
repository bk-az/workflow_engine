require 'faker'

FactoryGirl.define do
  factory :company do
    name { Faker::Name.first_name }
    subdomain { Faker::Name.first_name }
    owner_id 1
  end
end