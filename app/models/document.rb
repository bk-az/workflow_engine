class Document < ActiveRecord::Base
  belongs_to :company
  belongs_to :issue
end
