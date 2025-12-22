class AddCategoryAndLanguageToQuizQuestions < ActiveRecord::Migration[7.1]
  def change
    add_reference :quiz_questions, :quiz_category, foreign_key: true
    add_column :quiz_questions, :language, :integer, null: false, default: 0

    add_index :quiz_questions, :language
  end
end
