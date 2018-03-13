class CreateCompleteds < ActiveRecord::Migration
  def change
    create_table :completeds do |t|
      t.integer :take_score
      t.boolean :isview

      t.timestamps
    end
  end
end
