class CreateGlossaries < ActiveRecord::Migration
  def change
    create_table :glossaries do |t|
      t.string :name
      t.text :description
      t.text :syntax
      t.text :example

      t.timestamps
    end
  end
end
