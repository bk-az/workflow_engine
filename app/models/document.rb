class Document < ActiveRecord::Base
  belongs_to :company

  # A document can belong to either an issue or a project
  belongs_to :documentable, polymorphic: true

  has_attached_file :document


has_attached_file :document
validates_attachment :document, :content_type => { :content_type => %w(image/jpeg image/jpg image/png image/gif application/pdf application/msword application/vnd.ms-excel application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.openxmlformats-officedocument.spreadsheetml.sheet text/plain text/css application/js text/plain text/x-json application/json application/javascript application/x-javascript text/javascript text/x-javascript text/x-json
     text/html application/xhtml application/xml text/xml text/js) }, size: { less_than: 20.megabyte }

end
