class StudentsController < ApplicationController
  def index
    @student = Student.new
    
  end

  def new
    @student = Student.new

    @footer = "position: fixed;width: 100%;"
  end

  def create
    
    @student = Student.new(params.require(:student).permit(:fullname, :email, :username, :password))
    @student.student_validate = true
    
    respond_to do |format|
      if @student.save
        session["user_id"] = Student.last.id

        # Шинээр бүртгүүлсэн суралцагчийн, эхний үзэх хичээлийг зааж өгнө
        format.html{ redirect_to :signin, notice: "Таныг амжилттай бүртгэлээ :)" }
        format.json{ render action: "code", status: :created, location: @student}
        format.js{ render action: "code", status: :created, location: @student }
      else
        format.html{ render action: "new" }
        format.json{ render json: @student.errors, status: :unprocessable_entity }
        format.json{ render json: @student.errors, status: :unprocessable_entity }
      end
    end


  end

  def badge
    student_info
    @badges = Badge.where("student_id = ?", session["user_id"])


  end

  def delete
  end

  def signin
    @student = Student.new

    @footer = "position: fixed;
width: 100%;"
  end

  def create_sign # Нэвтрэх хэсгийн шалгалт
    @student = Student.new
    
    if Student.find_by(username: params[:student][:username], password: params[:student][:password]).blank?
      @student_error = "Хэрэглэгчийн нэр эсвэл нууц үг буруу байна"
      render action: "signin"
    else
      session["user_id"] = Student.where("username = ? AND password = ?", params[:student][:username], params[:student][:password]).first.id
      
      redirect_to :chapter1
    end
  end


  def show
    student_info
  end

  def update
    student_info
    @student = Student.find(session["user_id"])
    
    if params[:commit]
      @student.student_validate = true
      if @student.update_attributes(student_params)
        redirect_to :show
      else 
        render "update"  
      end
    end 

  end

  private 
    def student_info
      @student_info = Student.find(session["user_id"])

      @name = @student_info.fullname

      if @student_info.picture.blank?
        @image = "/assets/default_75.png"
      else
        @image = @student_info.picture
      end
      if @student_info.about.blank?
        @about = " Хоосон байна"
      else
        @about = @student_info.about
      end
      if @student_info.location.blank?
        @location = " Хоосон байна"
      else
        @location = @student_info.location
      end
      if @student_info.username.blank?
        @username = " Хоосон байна"
      else
        @username = @student_info.username
      end
      if @student_info.email.blank?
        @email = " Хоосон байна"
      else
        @email = @student_info.email
      end
      if @student_info.created_at.blank?
        @created_at = " Хоосон байна"
      else
        @created_at = @student_info.created_at
      end
      if @student_info.total_score.blank?
        @score = 0
      else
        @score = @student_info.total_score
      end

      @last_coded = Completed.where("student_id = ?", session["user_id"]).order("created_at desc").first.created_at
      @last_day = (Time.now.to_date - @last_coded.to_date).to_i
      @last_coded = @last_coded.to_date
      
      @total_scores = Completed.where("student_id = ?", session["user_id"]).sum(:take_score)
      @today_scores = Completed.where("student_id = ? and created_at >= ?", session["user_id"],Time.zone.now.beginning_of_day).sum(:take_score)
      @total_date = (Time.now.to_date - @student_info.created_at.to_date).to_i

      @badges = Badge.where("student_id = ?", session["user_id"]).order("created_at desc").take(5)
      @lessons = Completed.where("student_id = ?", session["user_id"]).order("created_at desc").take(15)
      
      @all_badges = Badge.where("student_id = ?", session["user_id"])
      
    end

    def student_params
      params.require(:student).permit(:username, :email, :fullname, :password, :about, :location, :picture)
    end


end
