class QuizQuestion < ApplicationRecord
  enum :language, { en: 0, vi: 1 }

  belongs_to :quiz_category, optional: true
  has_one_attached :image, dependent: :purge_later

  validates :title, presence: true
  validates :answers, presence: true
  validates :correct_answer_index, presence: true
  validates :language, presence: true

  validate :correct_answer_index_within_bounds
  validate :acceptable_image

  scope :for_locale, ->(locale) { where(language: locale.to_s) }

  private

  def acceptable_image
    return unless image.attached?

    # Validate content type
    acceptable_types = ["image/png", "image/jpeg", "image/gif"]
    errors.add(:image, :invalid_content_type) unless acceptable_types.include?(image.content_type)

    # Validate file size (10MB max)
    errors.add(:image, :file_too_large) if image.byte_size > 10.megabytes
  end

  def correct_answer_index_within_bounds
    return if answers.blank? || correct_answer_index.blank?

    correct_answer_index.each do |index|
      if index.negative? || index >= answers.length
        errors.add(:correct_answer_index, "must be within the range of answers (0-#{answers.length - 1})")
      end
    end
  end
end
