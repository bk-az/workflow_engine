# Controller for comments model. Comments are to be shown on projects and issues
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, except: [:edit, :update, :destroy]
  before_action :current_comment, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = t('comments.create.created')
    else
      flash[:alert] = t('comments.create.not_created')
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.js
      end
      flash[:notice] = t('comments.update.updated')
    else
      # how to show the errors
      render 'edit'
      flash[:notice] = t('comments.update.not_updated')
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = t('comments.destroy.destroyed')
      respond_to do |format|
        format.js
      end
    else
      flash[:notice] = t('comments.destroy.not_destroyed')
    end
  end

  private

  def load_commentable
    if params[:project_id].present?
      @commentable = Project.find(params[:project_id])
    elsif params[:issue_id].present?
      @commentable = Issue.find(params[:issue_id])
    end
  end

  def current_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
