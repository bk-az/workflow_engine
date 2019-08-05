class DocumentsController < ApplicationController
  def index
    @issue_id = params[:issue_id]
    @project_id = params[:project_id]
    if params[:issue_id] ## called via issue
      @issue_documents = Issue.find(params[:issue_id]).documents
    else ## called via projects
      @project_documents = Project.find(params[:project_id]).documents

    end
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.company_id = 1
    @document.path = @document.document.url
    if params[:issue_id]
      @document.documentable_type = 'Issue'
      @document.documentable_id = params[:issue_id]
      @path = issue_path(params[:issue_id])

    elsif params[:project_id]
      @document.documentable_type = 'Project'
      @document.documentable_id = params[:project_id]
      @path = project_path(params[:project_id])

    end
    if @document.save
      redirect_to @path, save_document: t('.save_document') # redirect to show page
    else
      render 'new', document_not_saved: t('.Document not saved!')
    end
  end

  def destroy
    @document = Document.find(params[:id])
    if params[:issue_id]
      @path = issue_path(params[:issue_id])
    else
      @path = project_path(params[:project_id])
    end
    if @document.destroy
      redirect_to @path, delete_document: t('.Successfully deleted document!')
    else
      render 'index', document_not_delete: t('.Error deleting Document!')
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


  # def download
  #   download = Document.find(params[:id])
  #   send_file download.document.path,
  #   :filename => download.document_file_name,
  #   :type => download.document_content_type,
  #   :disposition => 'attachment'
  #   flash[:notice] = "Your file has been downloaded"
  # end
end
