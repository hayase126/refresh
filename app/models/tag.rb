class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :post, through: :taggings

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "created_at", "updated_at"]
  end
end
