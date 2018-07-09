class CommentsController < ApplicationController
  before_action :load_post

  def new
  end

  def create
    @comment = @post.comments.create!(comment_params.merge(commenter: current_user))
  end

  private

  def load_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    parent_comment_id = params.require(:comment)[:parent_comment_id]
    parent_comment = @post.comments.find_by(id: parent_comment_id) if parent_comment_id.present?
    params.require(:comment).permit(:content).merge(parent: parent_comment )
  end
end
