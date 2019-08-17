require 'faker'

def debug(msg)
  puts '+++++++++++++++++++++++++++'
  puts msg
  puts '+++++++++++++++++++++++++++'
end

# description = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type'

# debug('Company')
# # Creating Company
# company = Company.create(name: '7vals', subdomain: '7vals', owner_id: 1, description: description)

# # set current tenant
# Company.current_id = company.id

# debug('Roles')
# # Creating Roles
# Role.create([{ name: 'Administrator' }, { name: 'Member' }])

debug('Owner')
# Creating Owner
owner = User.create( first_name: 'abubakar', last_name: 'azeem',
                     email: 'abubakar.azeem@7vals.com',
                     password: '123456789', role_id: Role.first.id,
                     company_id: 1, confirmed_at: Date.today)

debug('Members')
# Creating 9 Members
1.upto(9) do |i|
  User.create( first_name: "Member#{i}", last_name: 'Last Name',
               email: "member#{i}@7vals.com",
               password: '123456789', role_id: Role.last.id,
               company_id: 1, confirmed_at: Date.today)
end

# debug('Projects and Issues')
# # Creating 5 Projects each having 9 issues
# 1.upto(20) do |i|
#   project = Project.create( title: Faker::Company.buzzword.titleize, description: description,
#                             company_id: company.id)
#   3.times do
#     begin
#       project.users << User.find(2 + rand(9))
#     rescue Exception
#     end
#   end
#   1.upto(9) do |j|
#     Issue.create( title: Faker::Company.buzzword.titleize, description: description,
#                   company_id: company.id, creator_id: owner.id,
#                   assignee_id: User.find(2 + rand(9)).id,
#                   project_id: project.id,
#                   issue_type_id: IssueType.find(1 + rand(2)).id,
#                   issue_state_id: IssueState.find(1 + rand(2)).id,
#                   due_date: Date.today, start_date: Date.yesterday)
#   end
# end

# 1.upto(10) do |i|
#   Team.create(name: "Team#{i}", company_id: company.id)
# end
