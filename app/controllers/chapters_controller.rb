class ChaptersController < ApplicationController
  before_action :new_chapter

  def show
    all_chapters

  end

  def new

  end

  def create
    @chapter = Chapter.new(chapter_params)
    
    respond_to do |format|
      if @chapter.save
        
        format.html{ redirect_to :chaptershow, notice: "Таныг амжилттай бүртгэлээ :)" }
        format.json{ render action: "create", status: :created, location: @chapter}
        format.js{ render action: "create", status: :created, location: @chapter }
      else
        format.html{ render action: "new" }
        format.json{ render json: @chapter.errors, status: :unprocessable_entity }
        format.json{ render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @chapter = Chapter.find(params[:id])
  end

  def edit
    @chapter = Chapter.find(params[:id])
    if @chapter.update_attributes(chapter_params)
      flash[:success] = "Бүлэг засагдлаа"
      redirect_to :chaptershow
      
    else
      render action: "update"
    end
  end

  def destroy
    all_chapters
    Chapter.find(params[:id]).destroy
    flash[:success] = "Бүлэг устгагдлаа"
    render :show

  end

  def index
  end

  private
    def new_chapter
      @chapter = Chapter.new
    end
    def all_chapters
      @chapters = Chapter.all
    end
    def chapter_params
      params.require(:chapter).permit(:name, :badge_name, :description, :attachment, :organizer_id)
    end
    
end
