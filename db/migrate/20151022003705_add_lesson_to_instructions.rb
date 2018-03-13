class AddLessonToInstructions < ActiveRecord::Migration
  def change
    add_reference :instructions, :lesson, index: true
  end
end
