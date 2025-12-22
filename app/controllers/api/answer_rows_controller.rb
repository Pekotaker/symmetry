module Api
  class AnswerRowsController < Api::BaseController
    def create
      index = params[:index].to_i
      letter = ('A'.ord + index).chr

      render partial: "admin/quiz_questions/answer_row", locals: {
        index: index,
        letter: letter,
        value: "",
        is_correct: false
      }
    end
  end
end

