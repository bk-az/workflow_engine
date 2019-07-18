class IssueType < ActiveRecord::Base
  has_many :issues
  belongs_to :company
  belongs_to :project
end
