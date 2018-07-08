class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :load_post, only: [:show, :edit, :update, :destroy]

  def index
    posts = Post.all.order(created_at: :desc)
    @posts = posts.page(params[:page])
    @posts_count = posts.count
  end

  def new
    @posts_count = current_user.posts.count + 1
    @post = current_user.posts.new
  end

  def create
    @posts_count = current_user.posts.count + 1
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @posts_count = current_user.posts.count
  end

  def update
    @posts_count = current_user.posts.count + 1
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:should, :but, :result)
  end
end
