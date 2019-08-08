FactoryGirl.define do

  
  factory :team do
    name 'Team 1'
    company_id '2'
    sequence(:sequence_num) {|n| n } 
  end

  factory :invalid_team, parent: :team do
    name nil
  end
end