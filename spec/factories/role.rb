require 'faker'

FactoryGirl.define do
  factory :role_admin, class: Role do |f|
    f.name 'Administrator'
  end

  factory :role_member, class: Role do |f|
    f.name 'Member'
  end
end
