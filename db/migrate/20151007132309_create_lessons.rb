class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.text :theory
      t.text :theory_example
      t.text :instruction
      t.string :answer
      t.text :code
      t.integer :score
      t.integer :sub_score
      t.boolean :is_exercise

      t.timestamps
    end
  end
end
