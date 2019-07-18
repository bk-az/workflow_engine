class IssueState < ActiveRecord::Base
  has_many :issues
  belongs_to :company
  belongs_to :issue
end
