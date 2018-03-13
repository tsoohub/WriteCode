class MediaController < ApplicationController
  before_action :new_video

  def index
    student_image
    all_media

    
  end

  def new
  end

  def create
    @media = Media.new(video_params)

    respond_to do |format|
      if @media.save
        format.html{ redirect_to :mediashow, notice: "Таныг амжилттай бүртгэлээ :)" }
        format.json{ render action: "create", status: :created, location: @media}
        format.js{ render action: "create", status: :created, location: @media }
      else
        format.html{ render action: "new" }
        format.json{ render json: @media.errors, status: :unprocessable_entity }
        format.json{ render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @media = Media.find(params[:id])
  end

  def edit
    @media = Media.find(params[:id])
    if @media.update_attributes(video_params)
      flash[:success] = "Бичлэг засагдлаа"
      redirect_to :mediashow
      
    else
      render action: "update"
    end
  end

  def destroy
    all_media
    Media.find(params[:id]).destroy
    flash[:success] = "Бичлэг устгагдлаа"
    render :show

  end

  def show
    all_media
    
  end

  private 
    def all_media
      @media_s = Media.all
    end
    def student_image
      @student_info = Student.find(session["user_id"])
      if @student_info.picture.blank?
        @image = "/assets/default_75.png"
      else
        @image = @student_info.picture
    end
    end

    def video_params
      params.require(:media).permit(:name, :attachment, :organizer_id, :video)
    end
    def new_video
      @media = Media.new
    end
end
