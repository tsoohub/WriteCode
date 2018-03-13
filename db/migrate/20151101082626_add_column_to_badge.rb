class AddColumnToBadge < ActiveRecord::Migration
  def change
  	add_column :badges, :student_id, :integer
  	add_column :badges, :chapter_id, :integer
  end
end