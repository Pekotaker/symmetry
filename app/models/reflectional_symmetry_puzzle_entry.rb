class ReflectionalSymmetryPuzzleEntry < ApplicationRecord
  belongs_to :reflectional_symmetry_puzzle

  has_one_attached :left_image, dependent: :purge_later
  has_one_attached :right_image, dependent: :purge_later
  has_rich_text :trivia

  validate :images_present
  validate :acceptable_images

  private

  def images_present
    errors.add(:left_image, :blank) unless left_image.attached?
    errors.add(:right_image, :blank) unless right_image.attached?
  end

  def acceptable_images
    [[:left_image, left_image], [:right_image, right_image]].each do |name, image|
      next unless image.attached?

      acceptable_types = ["image/png", "image/jpeg", "image/gif"]
      errors.add(name, :invalid_content_type) unless acceptable_types.include?(image.content_type)
      errors.add(name, :file_too_large) if image.byte_size > 10.megabytes
    end
  end
end
