class AddChapterToLessons < ActiveRecord::Migration
  def change
    add_reference :lessons, :chapter, index: true
  end
end
