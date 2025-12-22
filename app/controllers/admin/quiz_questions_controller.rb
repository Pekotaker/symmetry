class Admin::QuizQuestionsController < Admin::BaseController
  before_action :set_quiz_question, only: [:show, :edit, :update, :destroy]
  before_action :load_categories, only: [:new, :edit, :create, :update]

  def index
    @quiz_questions = policy_scope(QuizQuestion).includes(:quiz_category).order(created_at: :desc)
    authorize QuizQuestion

    # Filter by language
    if params[:language].present? && QuizQuestion.languages.key?(params[:language])
      @quiz_questions = @quiz_questions.where(language: params[:language])
    end

    # Filter by category
    if params[:category].present?
      @quiz_questions = @quiz_questions.where(quiz_category_id: params[:category])
    end

    @languages = QuizQuestion.languages.keys
    @categories = QuizCategory.order(:language, :name)
  end

  def show
    authorize @quiz_question
  end

  def new
    @quiz_question = QuizQuestion.new(language: I18n.locale)
    authorize @quiz_question
  end

  def edit
    authorize @quiz_question
  end

  def create
    @quiz_question = QuizQuestion.new(quiz_question_params)
    authorize @quiz_question

    if @quiz_question.save
      redirect_to admin_quiz_questions_path, notice: t("admin.quiz_questions.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @quiz_question

    if @quiz_question.update(quiz_question_params)
      redirect_to admin_quiz_questions_path, notice: t("admin.quiz_questions.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @quiz_question
    @quiz_question.destroy
    redirect_to admin_quiz_questions_path, notice: t("admin.quiz_questions.deleted")
  end

  private

  def set_quiz_question
    @quiz_question = QuizQuestion.find(params[:id])
  end

  def load_categories
    @categories = QuizCategory.order(:language, :name)
  end

  def quiz_question_params
    params.require(:quiz_question).permit(:title, :content, :image, :language, :quiz_category_id, answers: [], correct_answer_index: [])
  end
end
