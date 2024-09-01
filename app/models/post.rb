class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :post_image, PostImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65_535 }

  def post_image_present?
    post_image.present?
  end
end
