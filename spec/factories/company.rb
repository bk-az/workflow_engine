require 'faker'

FactoryGirl.define do
  factory :company do
    name { 'company' }
    subdomain { '7vals' }
    owner_id 1
  end
end