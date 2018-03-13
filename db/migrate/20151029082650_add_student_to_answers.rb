class AddStudentToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :student, index: true
  end
end
