class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz_question, only: [:show]

  def index
    @categories = QuizCategory.for_locale(I18n.locale)
    @quiz_questions = QuizQuestion.for_locale(I18n.locale).includes(:quiz_category)

    if params[:category].present?
      @quiz_questions = @quiz_questions.where(quiz_category_id: params[:category])
      @current_category = @categories.find_by(id: params[:category])
    end

    @quiz_questions = @quiz_questions.order(created_at: :desc)
  end

  def show
    @quiz_questions = QuizQuestion.for_locale(I18n.locale)
    @quiz_questions = @quiz_questions.where(quiz_category_id: @quiz_question.quiz_category_id) if @quiz_question.quiz_category_id.present?
    @quiz_questions = @quiz_questions.order(created_at: :desc)

    @current_index = @quiz_questions.to_a.index(@quiz_question)
    @prev_question = @current_index && @current_index > 0 ? @quiz_questions[@current_index - 1] : nil
    @next_question = @current_index && @current_index < @quiz_questions.length - 1 ? @quiz_questions[@current_index + 1] : nil
  end

  private

  def set_quiz_question
    @quiz_question = QuizQuestion.find(params[:id])
  end
end
