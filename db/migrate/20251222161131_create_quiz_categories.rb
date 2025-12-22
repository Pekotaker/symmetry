class CreateQuizCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_categories do |t|
      t.string :name, null: false
      t.text :description
      t.integer :language, null: false, default: 0

      t.timestamps
    end

    add_index :quiz_categories, :language
  end
end
