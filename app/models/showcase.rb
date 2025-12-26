class Showcase < ApplicationRecord
  enum :symmetry_type, { reflectional: 0, point: 1 }

  has_one_attached :image, dependent: :purge_later
  has_rich_text :content

  validates :title, presence: true
  validates :symmetry_type, presence: true
  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    acceptable_types = ["image/png", "image/jpeg", "image/gif"]
    errors.add(:image, :invalid_content_type) unless acceptable_types.include?(image.content_type)
    errors.add(:image, :file_too_large) if image.byte_size > 10.megabytes
  end
end
