class QuizCategory < ApplicationRecord
  enum :language, { en: 0, vi: 1 }

  has_many :quiz_questions, dependent: :nullify

  validates :name, presence: true
  validates :language, presence: true

  scope :for_locale, ->(locale) { where(language: locale.to_s) }
end
