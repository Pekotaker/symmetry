class Showcase < ApplicationRecord
  enum :symmetry_type, { reflectional: 0, point: 1 }, prefix: true

  has_one_attached :image, dependent: :purge_later
  has_one_attached :video, dependent: :purge_later
  has_rich_text :content

  validates :title, presence: true
  validate :acceptable_image
  validate :acceptable_video

  private

  def acceptable_image
    return unless image.attached?

    acceptable_types = ["image/png", "image/jpeg", "image/gif"]
    errors.add(:image, :invalid_content_type) unless acceptable_types.include?(image.content_type)
    errors.add(:image, :file_too_large) if image.byte_size > 10.megabytes
  end

  def acceptable_video
    return unless video.attached?

    acceptable_types = ["video/mp4", "video/webm", "video/quicktime"]
    errors.add(:video, :invalid_content_type) unless acceptable_types.include?(video.content_type)
    errors.add(:video, :file_too_large) if video.byte_size > 100.megabytes
  end
end
