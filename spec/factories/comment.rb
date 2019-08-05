require 'faker'

FactoryGirl.define do
  factory :comment do |f|
    f.company_id 1
    f.content { Faker::Lorem.paragraph }
  end

  factory :invalid_comment, parent: :comment do |f|
    f.content nil
  end
end
