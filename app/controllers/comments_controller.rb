# Controller for comments model. Comments are to be shown on projects and issues
class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project, only: %i[new create], find_by: :sequence_num
  load_and_authorize_resource :issue, only: %i[new create], find_by: :sequence_num
  load_and_authorize_resource through: %i[project issue], only: %i[new create]
  load_and_authorize_resource except: %i[new create]

  # GET /issues/:issue_id/comments/new
  # GET /projects/:project_id/comments/new
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /projects/:project_id/comments
  # POST /issues/:issue_id/comments
  def create
    @comment.user_id = current_user.id
    if @comment.save
      flash.now[:notice] = t('comments.create.success')
    else
      flash.now[:error] = @comment.errors.full_messages
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
    @is_updated = false
    if @comment.update(comment_params)
      flash.now[:notice] = t('comments.update.success')
    else
      flash.now[:error] = @comment.errors.full_messages
      @is_updated = true
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /comments/:id(.:format)
  def destroy
    if @comment.destroy
      flash.now[:notice] = t('comments.destroy.success')
    else
      flash.now[:error] = @comment.errors.full_messages
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
