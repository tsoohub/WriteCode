class OrganizersController < ApplicationController
  def index
    @organizer = Organizer.find(session["admin_id"] )
    @chapter = Chapter.all
    @student = Student.order("created_at desc").take(6)
    @videos = Media.order("created_at desc").take(8)

  end

  def new
    user_admin

  end

  def create
    user_admin
    
    @organizer = Organizer.new(organizer_params)

    respond_to do |format|
      if @organizer.save
        session["admin_id"] = Organizer.last.id

        # Шинээр бүртгүүлсэн суралцагчийн, эхний үзэх хичээлийг зааж өгнө
        format.html{ redirect_to :admin, notice: "Таныг амжилттай бүртгэлээ :)" }
        format.json{ render action: "create", status: :created, location: @organizer}
        format.js{ render action: "create", status: :created, location: @organizer }
      else
        format.html{ render action: "new" }
        format.json{ render json: @organizer.errors, status: :unprocessable_entity }
        format.json{ render json: @organizer.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @organizer = Organizer.find(session["admin_id"])

  end

  def edit
    @organizer = Organizer.find(session["admin_id"])

    if @organizer.update_attributes(organizer_params)
      flash[:success] = "Мэдээлэл шинэчлэгдлээ"
      redirect_to :profile
    else
      render action: "update"
    end
  end

  def destroy
    @organizerAll = Organizer.all
    Organizer.find(params[:id]).destroy
    flash[:success] = "Зохион байгуулагч устгагдлаа"
    render :admin
    
  end

  def login
    user_admin

    if params[:commit] == "Нэвтрэх"
      if Organizer.find_by(email: params[:organizer][:email], password: params[:organizer][:password]).blank?
        @login_error = "Имэйл эсвэл нууц үг буруу"
      else
        session["admin_id"] = Organizer.where("email = ? AND password = ?", params[:organizer][:email], params[:organizer][:password]).first.id

        redirect_to :adminindex
      end
    end
  end

  def admin
    user_admin
    @organizerAll = Organizer.all
  end

  def profile
    @organizer = Organizer.find(session["admin_id"])
    
  end


  def admin_logout
    session["admin_id"] = nil
    redirect_to :adminlogin
  end

  private
    def user_admin
      @organizer = Organizer.new
    end

    def organizer_params
      params.require(:organizer).permit(:fullname, :email, :major, :password, :attachment, :about_me, :type)
    end
end
