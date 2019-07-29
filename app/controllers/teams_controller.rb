class TeamsController < ApplicationController

  def index
    # @issue_id = params[:issue_id]
    # if params[:issue_id] ## called via issue
    #   @issue_documents = Issue.find(params[:issue_id]).documents
    # else ## called via projects
    #   @project_documents = Project.find(params[:project_id]).documents

    # end
    @all_teams = Team.all
  end


  def new
    @document = Team.new
  end

  def show
    @team = Team.find(params[:id])
  end

  def create
    # @document = Document.new(document_params)
    # @document.company_id = 1
    # @document.path = @document.document.url
    # if params[:issue_id]
    #   @document.documentable_type = 'Issue'
    #   @document.documentable_id = params[:issue_id]

    # elsif params[:project_id]
    #   @document.documentable_type = 'Project'
    #   @document.documentable_id = params[:project_id]

    # end
    # if @document.save
    #   flash[:save_document] = 'Document saved successfully!'
    #   redirect_to new_issue_path # redirect to show page
    # else
    #   flash[:document_not_saved] = 'Document not saved!'
    #   render 'new'
    # end
  end

  def destroy
    # @document = Document.find(params[:id])
    # if @document.destroy
    #   flash[:delete_document] = 'Successfully deleted document!'
    #   redirect_to new_issue_path
    # else
    #   flash[:alert] = 'Error deleting Document!'
    # end
  end

  def team_params
    params.require(:team).permit(:name,:company_id)
                                     
  end



end
