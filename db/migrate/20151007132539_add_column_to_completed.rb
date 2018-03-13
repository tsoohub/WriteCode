class AddColumnToCompleted < ActiveRecord::Migration
  def change
  	add_column :completeds, :student_id, :integer
  	add_column :completeds, :lesson_id, :integer
  end
end
