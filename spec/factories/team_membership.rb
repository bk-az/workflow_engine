FactoryGirl.define do
  factory :team_membership do
    is_team_admin true
    is_approved true
    team_id 1
    user_id 1
  end

  # factory :invalid_team, parent: :team do
  #   name nil
  # end
end