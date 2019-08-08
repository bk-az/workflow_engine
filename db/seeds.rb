# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def debug(msg)
  puts '+++++++++++++++++++++++++++'
  puts msg
  puts '+++++++++++++++++++++++++++'
end

description = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type'

debug('Company')
# Creating Company
company = Company.create(name: '7vals', subdomain: '7vals', owner_id: 1, description: description)

# set current tenant
Company.current_id = company.id

debug('Roles')
# Creating Roles
Role.create([{ name: 'Administrator' }, { name: 'Member' }])

debug('Owner')
# Creating Owner
owner = User.create( first_name: 'abubakar', last_name: 'azeem',
                     email: 'muhammad.basil@7vals.com',
                     password: '123456789', role_id: Role.first.id,
                     company_id: 1, confirmed_at: Date.today)

# debug('Updating Owner')
# # Updating owner
# owner.company_id = company.id
# owner.save

# debug('IssueType States')
# # Creating Issues types and states
# IssueState.create([ { name: 'Unresolved', company_id: company.id },
#                     { name: 'Resolved', company_id: company.id }])

# IssueType.create([  { name: 'Improvement', company_id: company.id },
#                     { name: 'New Feature', company_id: company.id }])

debug('Members')
# Creating 9 Members
1.upto(9) do |i|
  User.create( first_name: "Member#{i}", last_name: 'Last Name',
               email: "member#{i}@7vals.com",
               password: '123456789', role_id: Role.last.id,
               company_id: company.id, confirmed_at: Date.today)
end

debug('Projects and Issues')
# Creating 5 Projects each having 9 issues
1.upto(5) do |i|
  project = Project.create( title: "Project#{i}", description: description,
                            company_id: company.id)
  1.upto(9) do |j|
    Issue.create( title: "Issue#{j}", description: description,
                  company_id: company.id, creator_id: owner.id,
                  assignee_id: User.find(2 + rand(9)).id,
                  project_id: project.id,
                  issue_type_id: IssueType.find(1 + rand(2)).id,
                  issue_state_id: IssueState.find(1 + rand(2)).id)
  end
end