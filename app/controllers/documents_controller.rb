class DocumentsController < ApplicationController
  def index
    @issue_id = params[:issue_id]
    if params[:issue_id] ## called via issue
      @issue_documents = Issue.find(params[:issue_id]).documents
    else ## called via projects
      @project_documents = Project.find(params[:project_id]).documents

    end
  end

  def new
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.company_id = 1
    @document.path = @document.document.url
    if params[:issue_id]
      @document.documentable_type = 'Issue'
      @document.documentable_id = params[:issue_id]

    elsif params[:project_id]
      @document.documentable_type = 'Project'
      @document.documentable_id = params[:project_id]

    end
    if @document.save
      flash[:save_document] = 'Document saved successfully!'
      redirect_to new_issue_path # redirect to show page
    else
      flash[:document_not_saved] = 'Document not saved!'
      render 'new'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    if @document.destroy
      flash[:delete_document] = 'Successfully deleted document!'
      redirect_to new_issue_path
    else
      flash[:alert] = 'Error deleting Document!'
    end
  end

  def document_params
    params.require(:document).permit(:path,
                                     :company_id,
                                     :document,
                                     :documentable_id,
                                     :documentable_type,
                                     :document_file_name,
                                     :document_file_size,
                                     :document_content_type)
  end
end
