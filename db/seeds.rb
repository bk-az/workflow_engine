require 'faker'

def debug(msg)
  puts '+++++++++++++++++++++++++++'
  puts msg
  puts '+++++++++++++++++++++++++++'
end

description = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type'

debug('Cleaning')
DatabaseCleaner.clean_with(:truncation)

debug('Company')
# Creating Company
company = Company.create(name: '7vals', subdomain: '7vals', owner_id: 1, description: description)
# company = Company.create(name: '8vals', subdomain: '8vals', owner_id: 1, description: description)

# set current tenant
Company.current_id = company.id

debug('Roles')
# Creating Roles
Role.create([{ name: 'Administrator' }, { name: 'Member' }])

debug('Owner')
# Creating Owner
owner = User.create( first_name: 'Admin', last_name: '7vals',
                     email: 'admin@7vals.com',
                     password: '123456789', role_id: Role.first.id,
                     company_id: 1, confirmed_at: Date.today)

debug('Members')
# Creating 9 Members
1.upto(9) do |i|
  User.create( first_name: "Member#{i}", last_name: 'Last Name',
               email: "member#{i}@7vals.com",
               password: '123456789', role_id: Role.last.id,
               company_id: company.id, confirmed_at: Date.today)
end

debug('Projects and Issues')
# Creating 10 Projects each having 9 issues, total 90 issues
1.upto(10) do |i|
  project = Project.create( title: Faker::Company.buzzword.titleize, description: description,
                            company_id: company.id)
  3.times do
    begin
      project.users << User.find(2 + rand(9))
    rescue Exception
    end
  end
  1.upto(9) do |j|
    Issue.create( title: Faker::Company.buzzword.titleize, description: description,
                  company_id: company.id, creator_id: owner.id,
                  assignee_id: User.find(1 + rand(9)).id,
                  project_id: project.id,
                  issue_type_id: IssueType.find(1 + rand(IssueType.count)).id,
                  issue_state_id: IssueState.find(1 + rand(IssueState.count)).id,
                  due_date: Date.new(2019, 8, (15 + rand(15))), start_date: Date.new(2019, 8, (1 + rand(15))))
  end
end

debug('Teams')
1.upto(10) do |i|
  team = Team.create(name: "Team#{i}", company_id: company.id)
  5.times do
    user = User.find(1+rand(10))
    team.users << user unless team.users.ids.include?(user.id)
  end
  team.team_memberships.first.update(is_team_admin: true)
end
TeamMembership.update_all(is_approved: true)

debug('Issue Watchers')
50.times do
  issue = Issue.find(1+rand(90))
  user = User.find(1+rand(10))
  team = Team.find(1+rand(10))
  issue.watcher_users << user unless issue.watcher_users.ids.include?(user.id)
  issue.watcher_teams << team unless issue.watcher_teams.ids.include?(team.id)
end
