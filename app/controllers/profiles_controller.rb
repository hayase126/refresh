class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    @user = current_user
    @like_posts = @user.like_posts.includes(:user).order(created_at: :desc)
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザーを更新しました"
      redirect_to profile_path
    else
      flash.now[:danger] = "ユーザーを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :profile_image_cache)
  end
end
