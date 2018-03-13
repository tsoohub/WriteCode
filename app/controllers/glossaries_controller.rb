class GlossariesController < ApplicationController
  def index
    student_info
    @glossary = Glossary.all
    
  end

  def show
    @glossary = Glossary.all
    
  end

  def new
    @glossary = Glossary.new
    
  end

  def create
    @glossary = Glossary.new(glossary_params)

    respond_to do |format|
      if @glossary.save
        format.html{ redirect_to :glossaryshow, notice: "Таныг амжилттай бүртгэлээ :)" }
        format.json{ render action: "create", status: :created, location: @glossary}
        format.js{ render action: "create", status: :created, location: @glossary }
      else
        format.html{ render action: "new" }
        format.json{ render json: @glossary.errors, status: :unprocessable_entity }
        format.json{ render json: @glossary.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @glossary = Glossary.find(params[:id])

  end

  def edit
    @glossary = Glossary.find(params[:id])
    if @glossary.update_attributes(glossary_params)
      flash[:success] = "Тайлбар засагдлаа"
      redirect_to :glossaryshow
    else
      render action: "update"
    end

  end

  def delete
  end

  def destroy
    @glossary = Glossary.all
    Glossary.find(params[:format]).destroy

    flash[:success] = "Тайлбар устгагдлаа"
    render :show
  end


  private
    def glossary_params
      params.require(:glossary).permit(:name, :description, :syntax, :example, :organizer_id)
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
