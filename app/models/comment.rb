class Comment < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  # A comment can belong to either an issue or a project
  belongs_to :commentable, polymorphic: true
end
