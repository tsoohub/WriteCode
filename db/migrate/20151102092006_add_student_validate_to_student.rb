class AddStudentValidateToStudent < ActiveRecord::Migration
  def change
    add_column :students, :student_validate, :boolean
  end
end
