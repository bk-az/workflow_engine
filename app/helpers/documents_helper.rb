module DocumentsHelper
  def get_documents_and_path
    if params[:issue_id].present?
      # @issue_documents = Issue.find(params[:issue_id]).documents
      documents = Issue.find(params[:issue_id]).documents
      path = issue_document_path(params[:issue_id])
    else
      # @project_documents = Project.find(params[:project_id]).documents
      documents = Project.find(params[:project_id]).documents
      path =  project_document_path(params[:project_id] )
    end
    return [documents, path]
  end

  def remove_extension_from_filename(filename)
    File.basename(filename, File.extname(filename))
  end

  def get_parent_of_document(project, issue)
    if issue.nil?
      @project
    else
      @issue
    end 
  end
          
end
