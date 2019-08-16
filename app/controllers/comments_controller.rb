# Controller for comments model. Comments are to be shown on projects and issues
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, except: [:edit, :update, :destroy]
  before_action :current_comment, only: [:edit, :update, :destroy]

  # GET /issues/:issue_id/comments/new
  # GET /projects/:project_id/comments/new
  def new
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /projects/:project_id/comments
  # POST /issues/:issue_id/comments
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash.now[:notice] = t('comments.create.created')
    else
      flash.now[:alert] = t('comments.create.not_created')
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /comments/:id/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # PATCH /comments/:id(.:format)
  # PUT /comments/:id(.:format)
  def update
    # @comment_invalid is made instance variable because it is used in update.js.erb file.
    @comment_invalid = false
    if @comment.update(comment_params)
      flash.now[:notice] = t('comments.update.updated')
    else
      flash.now[:notice] = t('comments.update.not_updated')
      flash.now[:error] = @comment.errors.full_messages
      @comment_invalid = true
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /comments/:id(.:format)
  def destroy
    if @comment.destroy
      flash.now[:notice] = t('comments.destroy.destroyed')
    else
      flash.now[:notice] = t('comments.destroy.not_destroyed')
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def load_commentable
    if params[:project_id].present?
      @commentable = current_tenant.projects.find(params[:project_id])
    elsif params[:issue_id].present?
      @commentable = current_tenant.issues.find(params[:issue_id])
    end
  end

  def current_comment
    @comment = current_tenant.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
