class DocumentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :issue, find_by: 'sequence_num'
  load_resource :project, find_by: 'sequence_num'
  load_and_authorize_resource :document, through: [:issue, :project]
  
  def index
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
    respond_to do |format|
      format.html do
        if @document.save
          flash[:notice] = t('document.create.success')
        else
          flash[:error] = @document.errors.full_messages
        end
        redirect_to :back
      end
    end
  end

  def destroy
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
