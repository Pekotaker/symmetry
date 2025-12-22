class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @quiz_questions = QuizQuestion.for_locale(I18n.locale).includes(:quiz_category).order(created_at: :desc)
  end
end
