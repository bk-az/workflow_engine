class DocumentsController < ApplicationController
  load_and_authorize_resource
  def index
    if params[:issue_id].present?
      @document_type = 'Issue'
      @issue_id = params[:issue_id]
      @documents = Issue.find(params[:issue_id]).documents
    else
      @document_type = 'Project'
      @documents = Project.find(params[:project_id]).documents
      @project_id = params[:project_id]
    end
    respond_to do |format|
      format.html
    end
  end

  def new
    @document = Document.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @new_document = Document.new(document_params)
    @new_document.company_id = current_tenant.id
    @new_document.path = @new_document.document.url
    if params[:issue_id].present?
      redirect_path = issue_path(params[:issue_id])
      documentable_type = 'Issue'
      documentable_id = params[:issue_id]
    elsif params[:project_id].present?
      redirect_path = project_path(params[:project_id])
      documentable_type = 'Project'
      documentable_id = params[:project_id]
    end
    @new_document.documentable_type = documentable_type
    @new_document.documentable_id = documentable_id
    if @new_document.save
      flash[:notice] = t('document.create.success')
      document_created = true
    else
      flash.now[:error] = @document.errors.full_messages
      document_created = false
    end
    respond_to do |format|
      format.html do
        if document_created
          redirect_to redirect_path
        else
          render 'new'
        end
      end
    end
  end

  def destroy
    @document = Document.find(params[:id])
    if params[:issue_id].present?
      redirect_path = issue_path(params[:issue_id])
    elsif params[:project_id].present?
      redirect_path = project_path(params[:project_id])
    end
    if @document.destroy
      flash[:notice] = t('document.destroy.success')
      document_destroyed = true
    else
      flash.now[:error] = @document.errors.full_messages
      document_destroyed = false
    end
    respond_to do |format|
      format.html do
        if document_destroyed
          redirect_to redirect_path
        else
          render 'new'
        end
      end
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
