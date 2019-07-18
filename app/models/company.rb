class Company < ActiveRecord::Base
  belongs_to :owner, class_name: 'User' # Owner
  has_many   :users
  has_many   :projects
  has_many   :teams
  has_many   :comments
  has_many   :issues
  has_many   :documents
  has_many   :issue_types
  has_many   :issue_states
end
