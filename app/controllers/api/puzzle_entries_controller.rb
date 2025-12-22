module Api
  class PuzzleEntriesController < Api::BaseController
    def create
      index = params[:index].to_i
      render partial: "admin/reflectional_symmetry_puzzles/entry_fields_new", locals: { index: index }
    end
  end
end

