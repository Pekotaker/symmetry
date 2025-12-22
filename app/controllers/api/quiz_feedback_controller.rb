module Api
  class QuizFeedbackController < Api::BaseController
    def show
      correct = params[:correct] == "true"
      render partial: "shared/quiz_feedback", locals: { correct: correct }
    end
  end
end

