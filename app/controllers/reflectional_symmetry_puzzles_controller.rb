class ReflectionalSymmetryPuzzlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_puzzle, only: [:show]

  def index
    @puzzles = ReflectionalSymmetryPuzzle.for_locale(I18n.locale)
                                         .includes(:entries)
                                         .order(created_at: :desc)
  end

  def show
    @entries = @puzzle.entries.includes(left_image_attachment: :blob, right_image_attachment: :blob)
  end

  private

  def set_puzzle
    @puzzle = ReflectionalSymmetryPuzzle.find(params[:id])
  end
end

