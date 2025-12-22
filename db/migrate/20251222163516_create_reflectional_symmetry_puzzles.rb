class CreateReflectionalSymmetryPuzzles < ActiveRecord::Migration[7.1]
  def change
    create_table :reflectional_symmetry_puzzles do |t|
      t.string :title, null: false
      t.text :description
      t.integer :language, null: false, default: 0

      t.timestamps
    end

    add_index :reflectional_symmetry_puzzles, :language
  end
end
