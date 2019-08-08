require 'faker'

FactoryGirl.define do
  factory :role do
    name 'Member'
  end

  factory :role_admin, class: Role do
    name 'Administrator'
  end

  factory :role_member, class: Role do
    name 'Member'
  end
end
