class CreateReflectionalSymmetryPuzzleEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :reflectional_symmetry_puzzle_entries do |t|
      t.references :reflectional_symmetry_puzzle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
