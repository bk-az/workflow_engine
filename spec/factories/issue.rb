FactoryGirl.define do
  factory :issue do
    title 'This is newly created issue'
    description 'Some description'
    start_date '2017-07-23'
    due_date '2017-07-23'
    progress '0'
    priority '2'
    company_id '1'
    creator_id '1'
    assignee_id '1'
    project_id '1'
    issue_type_id '1'
    issue_state_id '1'
  end

  factory :invalid_issue, parent: :issue do |f|
    f.title nil
  end
end
