class Document < ActiveRecord::Base
  belongs_to :company

  # A document can belong to either an issue or a project
  belongs_to :documentable, polymorphic: true
  # has_attached_file :image,
  #                 styles: { thumb: ['200x200#', :jpeg], thumb: ['200x200#', :png], original: [:jpeg] },
  #                 convert_options: {
  #                     thumb: '-quality 70 -strip',
  #                     original: '-quality 90'
  #                 }

  has_attached_file :document

  # has_attached_file :files
  # validates_attachment :files, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}

  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  # validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  # validates_attachment :image, presence: true, 
  #                    content_type: { content_type: %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)},
  #                    size: { less_than: 1.megabyte }


has_attached_file :document
validates_attachment :document, :content_type => { :content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.ms-excel application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.openxmlformats-officedocument.spreadsheetml.sheet) }

end
