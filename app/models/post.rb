class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  mount_uploader :post_image, PostImageUploader

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65_535 }

  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }

  def post_image_present?
    post_image.present?
  end

  def save_with_tags(tag_names:)
    ActiveRecord::Base.transaction do
      self.tags = tag_names.map { |name| Tag.find_or_initialize_by(name: name.strip) }
      save!
    end
    true
  rescue StandardError
    false
  end

  # 編集時デフォルトで表示するためのメソッド
  def tag_names
    # NOTE: pluckだと新規作成失敗時に値が残らない(返り値がnilになる)
    tags.map(&:name).join(',')
  end

  def self.ransackable_attributes(auth_object = nil)
    ["content", "title"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "tags"]
  end
end
