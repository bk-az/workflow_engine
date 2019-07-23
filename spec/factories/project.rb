require 'faker'

FactoryGirl.define do
  factory :project do |f|
    f.company_id 1
    f.title { Faker::Company.buzzword }
    f.description { Faker::Lorem.paragraph }
  end

  factory :invalid_project, parent: :project do |f|
    f.title nil
  end
end
