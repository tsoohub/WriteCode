class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name
      t.string :badge_name
      t.string :badge_image

      t.timestamps
    end
  end
end
