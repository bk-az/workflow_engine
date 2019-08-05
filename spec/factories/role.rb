<<<<<<< HEAD
require 'faker'
=======
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
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
