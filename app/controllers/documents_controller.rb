class DocumentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :issue , find_by: sequence_num
  load_resource :project , find_by: sequence_num
  load_and_authorize_resource 

  def index
    if params[:issue_id].present?
      @documents = @issue.documents
    elsif params[:project_id].present?
      @documents = @project.documents
    end
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    @document.path = @document.document.url
    if params[:issue_id].present?
      documentable_type = 'Issue'
      documentable_id = @issue.id
    elsif params[:project_id].present?
      documentable_type = 'Project'
      documentable_id = @project.id
    end
    @document.documentable_type = documentable_type
    @document.documentable_id = documentable_id
    respond_to do |format|
      format.html do
        if @document.save
          flash[:notice] = t('document.create.success')
        else
          flash.now[:error] = @document.errors.full_messages
        end
        redirect_to :back
      end
    end
  end

  def destroy
    @document = Document.find(params[:id])
    respond_to do |format|
      format.html do
        if @document.destroy
          flash[:notice] = t('document.destroy.success')
          redirect_to :back
        else
          flash.now[:error] = @document.errors.full_messages
        end
      end
    end
  end

  def document_params
    params
      .require(:document)
      .permit(:path, :company_id, :document, :documentable_id, :documentable_type, :document_file_name, :document_file_size, :document_content_type)
  end
end
