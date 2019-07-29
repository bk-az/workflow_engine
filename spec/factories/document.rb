include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :document do
    path '/system/documents/documents//original/doc.pdf?1564122619'
    company_id '1'

    # document fixture_file_upload(Rails.root.to_s + '/spec/fixtures/files/building.jpeg', 'img/jpeg') 
    # document File.open(File.join(Rails.root, 'spec', 'fixtures', 'building.jpeg'))

    documentable_id '1'
    documentable_type 'Issue'
    document_file_name 'doc.pdf'
    document_content_type 'application/pdf'
    document_file_size '7266'
  end

  factory :invalid_document, parent: :Issue do |f|
    f.company_id nil
  end
end

# company_id '1'
#     documentable_id '1'
#     documentable_type 'Issue'
#     document_file_name 'doc.pdf'
#     document_content_type 'application/pdf'
#     document_file_size '7266'