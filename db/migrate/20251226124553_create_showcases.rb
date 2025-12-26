class CreateShowcases < ActiveRecord::Migration[7.1]
  def change
    create_table :showcases do |t|
      t.string :title
      t.integer :symmetry_type

      t.timestamps
    end
  end
end
