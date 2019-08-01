FactoryGirl.define do
  factory :team do
    name 'Team 1'
    company_id '1'
  end

  factory :invalid_team, parent: :team do
    name nil
  end
end