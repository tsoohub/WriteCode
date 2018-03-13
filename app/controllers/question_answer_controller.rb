class QuestionAnswerController < ApplicationController
  def index
    student_info
  	@question = Question.new

  	@questions = Question.order("created_at DESC")

  end

  def create

    if params[:questions]
      @question = Question.new(question_param)
      if @question.save
        redirect_to :ques_answer
      end
    elsif params[:ques_answer]
      @answer = Answer.new(answer_param)
      if @answer.save
        redirect_to :ques_show
      end
    end

  end

  def show
    student_info
    @question = Question.find(session["question_id"])
    @answer = Answer.new

    @answers = Answer.where(question_id: session["question_id"])

    @last_answers = Answer.where(question_id: session["question_id"]).order("created_at desc").take(4)
      

  end

  def show_question
    session["question_id"] = params[:id]
    redirect_to :ques_show
  end

  def update
  end

  def delete
  end

  def booty
    
  end

  private 
  	def question_param
  		params.require(:question).permit(:title, :ques, :category, :picture, :student_id)
  	end
    def answer_param
      params.require(:answer).permit(:ans, :picture, :student_id, :question_id)
    end
    def student_info
      @student_info = Student.find(session["user_id"])
      if @student_info.picture.blank?
        @image = "/assets/default_75.png"
      else
        @image = @student_info.picture
      end
    end

end
