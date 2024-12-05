class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :profile_image, ProfileImageUploader

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] } # 3文字以上必要
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] } # passwordの値と一致する
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] } # 値が空でない

  validates :email, uniqueness: true, presence: true, length: { maximum: 255 } # 255文字以内
  validates :name, presence: true, length: { maximum: 255 } # name要素を入力必須、255文字以内

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  def own?(object)
    id == object&.user_id
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[email id name profile_image created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[posts]
  end
end
