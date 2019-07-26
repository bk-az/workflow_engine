# Controller for comments model. Comments are to be shown on projects and issues
class CommentsController < ApplicationController
  before_action :load_project
  before_action :current_comment, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @comment = @project.comments.build(comment_params)
    @comment.company_id = 1
    if @comment.save
      redirect_to @project, notice: t('comments.create.created')
    else
      redirect_to @project, alert: t('comments.create.not_created')
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @project, notice: t('comments.update.updated')
    else
      render 'edit'
      flash[:notice] = t('comments.update.not_updated')
    end
  end

  def destroy
    @comment.destroy
    redirect_to project_path(@project), notice: t('comments.destroy.deleted')
  end

  private

  def load_project
    @project = Project.find(params[:project_id])
  end

  def current_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
