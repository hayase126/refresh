class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: "投稿に成功しました"
    else
      flash.now[:alert] = "投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: t("defaults.message.deleted", item: Post.model_name.human)
  end

  def likes
    @like_posts = current_user.like_posts.includes(:user).order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_image, :post_image_cache)
  end
end
