FactoryGirl.define do
  factory :role do
    name 'Member'
  end

  factory :role_admin, class: Role, parent: :role do
    name 'Administrator'
  end

  factory :role_member, class: Role, parent: :role do
    name 'Member'
  end
end
