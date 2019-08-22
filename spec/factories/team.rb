# FactoryGirl.define do

#   factory :team do
#     name 'Team 1'
#     company_id '2'
#     sequence(:sequence_num) {|n| n }
#   end

#   factory :invalid_team, parent: :team do
#     name nil
#   end
# end
require 'faker'

FactoryGirl.define do
  factory :team do |f|
    f.company_id 1
    f.name { Faker::Team.name }
  end
  
end
