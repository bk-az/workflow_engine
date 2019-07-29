require 'rails_helper'

RSpec.describe Document, type: :model do
  # let(:company_id)      { '1' }
  # let(:path)      { '/system/documents/documents//original/interior3.jpeg?1564144299'}

  let(:document) do
    Document.new(
      path: '/system/documents/documents//original/interior3.jpeg?1564144299',
      company_id: '1',
      documentable_id: '1',
      documentable_type: 'Issue',
      document_file_name: 'doc.pdf',
      document_content_type: 'application/pdf',
      document_file_size: '7266'
    )
  end

  before :each do
    @document = FactoryGirl.create(:document)
  end

  context 'validation tests' do
    it 'returns true on company_id presence' do
      document.company_id = 1
      expect(document.valid?).to eq true
    end

    it 'ensures path presence' do
      document.path = '/system/documents/documents//original/interior3.jpeg?1564144299'
      expect(document.valid?).to eq true
    end

    it 'ensures documentable_id presence' do
      document.documentable_id = 1
      expect(document.valid?).to eq true
    end

    it 'ensures documentable_type presence' do
      document.documentable_type = 'Issue'
      expect(document.valid?).to eq true
    end

    it 'ensures document file name presence' do
      document.document_file_name = 'doc.pdf'
      expect(document.valid?).to eq true
    end

    it 'ensures document content type presence' do
      document.document_content_type = 'application/pdf'
      expect(document.valid?).to eq true
    end

    it 'ensures document file size presence' do
      document.document_file_size = '7266'
      expect(document.valid?).to eq true
    end
  end
end
