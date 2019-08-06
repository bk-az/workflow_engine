require 'faker'

FactoryGirl.define do
  factory :company do |f|
    f.name { Faker::Company.buzzword }
    f.subdomain { Faker::Internet.domain_name.split('.')[0] }
    owner_id 1
  end
end
