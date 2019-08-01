class IssueType < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: :company_id, case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: 20 })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :project
end
