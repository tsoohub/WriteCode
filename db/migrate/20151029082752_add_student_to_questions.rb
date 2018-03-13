class AddStudentToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :student, index: true
  end
end
