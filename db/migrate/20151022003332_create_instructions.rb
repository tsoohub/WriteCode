class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.string :command
      t.text :example
      t.text :answer

      t.timestamps
    end
  end
end
