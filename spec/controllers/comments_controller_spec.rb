require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:comment_attr) { FactoryGirl.attributes_for(:comment) }
  let(:invalid_comment_attr) { FactoryGirl.attributes_for(:invalid_comment) }
  let(:comment) { FactoryGirl.create(:comment) }
  let(:project) { FactoryGirl.create(:project) }

  describe 'POST #create', type: :feature do
    context 'with valid attributes' do
      it 'should save the new comment in the database' do
        expect do
          post :create, comment: comment_attr, project_id: project.id
        end.to change(Comment, :count).by(1)
        expect(flash[:notice]).to eq I18n.t('comments.create.created')
      end
    end

    context 'with invalid attributes' do
      it 'should not save the new comment in the database' do
        expect do
          post :create, comment: invalid_comment_attr, project_id: project.id
        end.to_not change(Comment, :count)
        expect(flash[:alert]).to eq I18n.t('comments.create.not_created')
      end
    end
  end

  describe 'PUT update' do
    let(:edit_comment) { 'I am editing this test comment.' }

    context 'valid attributes' do
      it 'should locate the requested @comment' do
        put :update, id: comment, comment: comment_attr, project_id: project.id
        expect(assigns(:comment)).to eq(comment)
      end

      it "should change the @comment's attributes" do
        put :update, id: comment, comment: FactoryGirl.attributes_for(
          :comment, content: edit_comment
        ), project_id: project.id

        comment.reload
        expect(comment.content).to eq(edit_comment)
      end

      it "should redirect to the updated comment's project" do
        put :update, id: comment, comment: comment_attr, project_id: project.id
        expect(response).to redirect_to project
        expect(flash[:notice]).to eq I18n.t('comments.update.updated')
      end
    end

    context 'invalid attributes' do
      it 'should locate the requested @comment' do
        put :update, id: comment, comment: invalid_comment_attr,
                     project_id: project.id
        expect(assigns(:comment)).to eq(comment)
      end

      it "should not change @comment's attributes" do
        put :update, id: comment,
                     comment: invalid_comment_attr,
                     project_id: project.id
        comment.reload
        expect(comment.content).to_not eq(edit_comment)
      end

      it 'should re-render the edit method' do
        put :update, id: comment, comment: invalid_comment_attr,
                     project_id: project.id
        expect(response).to render_template :edit
        expect(flash[:notice]).to eq I18n.t('comments.update.not_updated')
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @comment = FactoryGirl.create(:comment)
    end
    it 'should delete the comment' do
      expect { delete :destroy, id: @comment, project_id: project.id }
        .to change(Comment, :count).by(-1)
    end

    it 'should redirect to project#show' do
      delete :destroy, id: @comment, project_id: project.id
      expect(response).to redirect_to project
      expect(flash[:notice]).to eq I18n.t('comments.destroy.deleted')
    end
  end
end
