class Comment < ActiveRecord::Base
  validates :content, presence: true, length: { minimum: 3, maximum: 1024 }

  belongs_to :company
  belongs_to :user

  # A comment can belong to either an issue or a project
  belongs_to :commentable, polymorphic: true
end
