class AddQuestionToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :question, index: true
  end
end
