class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @q = Post.ransack(params[:q])

    posts = if (tag_name = params[:tag_name])
              @q.result(distinct: true).with_tag(tag_name)
            else
              @q.result(distinct: true).includes(:user, :tags)
            end
    @posts = posts.order(created_at: :desc).page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save_with_tags(tag_names: params.dig(:post, :tag_names).split(',').uniq)
      flash[:success] = '投稿に成功しました'
      redirect_to posts_path
    else
      flash.now[:alert] = t('defaults.message.not_created', item: Post.model_name.human)
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
    flash[:success] = '投稿を削除しました'
    redirect_to posts_path
  end

  def likes
    @like_posts = current_user.like_posts.includes(:user).order(created_at: :desc)
  end

  def search
    @posts = Post.where('title like ?', "%#{params[:q]}%")
    respond_to :js
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_image, :post_image_cache)
  end
end
