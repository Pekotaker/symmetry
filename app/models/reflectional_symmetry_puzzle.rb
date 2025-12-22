class ReflectionalSymmetryPuzzle < ApplicationRecord
  enum :language, { en: 0, vi: 1 }

  has_many :entries, class_name: "ReflectionalSymmetryPuzzleEntry", dependent: :destroy
  accepts_nested_attributes_for :entries, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :language, presence: true

  scope :for_locale, ->(locale) { where(language: locale.to_s) }
end
