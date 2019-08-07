class AddAttachmentDocumentToDocuments < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :documents, :document
  end
end
