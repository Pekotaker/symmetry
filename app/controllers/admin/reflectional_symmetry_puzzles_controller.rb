module Admin
  class ReflectionalSymmetryPuzzlesController < Admin::BaseController
    before_action :set_puzzle, only: [:show, :edit, :update, :destroy]

    def index
      @puzzles = policy_scope(ReflectionalSymmetryPuzzle).includes(:entries).order(created_at: :desc)
      authorize ReflectionalSymmetryPuzzle

      if params[:language].present? && ReflectionalSymmetryPuzzle.languages.key?(params[:language])
        @puzzles = @puzzles.where(language: params[:language])
      end

      @languages = ReflectionalSymmetryPuzzle.languages.keys
    end

    def show
      authorize @puzzle
    end

    def new
      @puzzle = ReflectionalSymmetryPuzzle.new(language: I18n.locale)
      @puzzle.entries.build
      authorize @puzzle
    end

    def edit
      authorize @puzzle
    end

    def create
      @puzzle = ReflectionalSymmetryPuzzle.new(puzzle_params)
      authorize @puzzle

      if @puzzle.save
        redirect_to admin_reflectional_symmetry_puzzle_path(@puzzle), notice: t("admin.reflectional_symmetry_puzzles.created")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize @puzzle

      if @puzzle.update(puzzle_params)
        redirect_to admin_reflectional_symmetry_puzzle_path(@puzzle), notice: t("admin.reflectional_symmetry_puzzles.updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @puzzle
      @puzzle.destroy
      redirect_to admin_reflectional_symmetry_puzzles_path, notice: t("admin.reflectional_symmetry_puzzles.deleted")
    end

    private

    def set_puzzle
      @puzzle = ReflectionalSymmetryPuzzle.find(params[:id])
    end

    def puzzle_params
      params.require(:reflectional_symmetry_puzzle).permit(
        :title, :description, :language,
        entries_attributes: [:id, :left_image, :right_image, :_destroy]
      )
    end
  end
end

