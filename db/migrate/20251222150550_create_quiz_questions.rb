class CreateQuizQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_questions do |t|
      t.string :title, null: false
      t.text :content
      t.string :answers, array: true, default: []
      t.integer :correct_answer_index, array: true, default: []

      t.timestamps
    end
  end
end
