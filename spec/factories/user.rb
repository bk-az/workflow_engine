require 'faker'

FactoryGirl.define do
<<<<<<< HEAD
  # factory :user do
  #   first_name  { Faker::Name.first_name }
  #   last_name   { Faker::Name.last_name }
  #   email       { Faker::Internet.email }
  #   password    { Faker::Internet.password }
  #   company_id 1
  #   association :role, factory: :role_member
  # end
=======
  factory :user do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    password    { Faker::Internet.password }
    confirmed_at { Date.today }
    company_id 1
    association :role, factory: :role_member
  end
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd

  factory :admin, class: User do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    password    { Faker::Internet.password }
<<<<<<< HEAD
=======
    confirmed_at { Date.today }
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
    company_id 1
    association :role, factory: :role_admin
  end

  factory :member, class: User do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    password    { Faker::Internet.password }
<<<<<<< HEAD
=======
    confirmed_at { Date.today }
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
    company_id 1
    association :role, factory: :role_member
  end
end
