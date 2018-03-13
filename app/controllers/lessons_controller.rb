class LessonsController < ApplicationController
  respond_to :html, :js
  before_action :new_lesson
  
  require 'Interpreters'

  def included_in? array
    array.to_set.superset(self.to_set)
  end

  def index
    student_info

    @lesson = Lesson.find(session["lesson_id"])
    @instructions = Instruction.where("lesson_id = ?", @lesson.id)
    #@correct_answer = [] # Зөв хийсэн зааврыг агуулна

    # ---------------------------- Badge тооцох хэсэг ---------------------------
    @ch_id = @lesson.chapter_id # Бүлгийн ID
    @current_chapter = Chapter.find(@ch_id)

    @ch_lessons = Chapter.find(@ch_id).lessons.count # Бүлэг доторх хичээлийн тоо
    @viewed_lesson = 0 # Бүлэг дотроос үзсэн хичээлүүдийн тоог хадгална
    @finish = false

    if params[:next] # Товч дарагдсан эсэхийг шалгана
      @next = true

      # -------------------- Дараагиийн товч дарагдсан үед тухайн хийсэн хичээлийг нь хадгална ----------------------
      if not Completed.exists?(:student_id => session["user_id"], :lesson_id => session["lesson_id"])
        Completed.create(take_score: params[:lesson][:score], isview: 1, student_id: session["user_id"], lesson_id: session["lesson_id"]) # Яахав дээ хийсэн хичээлийн  хадгалаж байна
      
        # -----------Суралцагчийн үзсэн хичээлүүд ----------------------
        @viewed = Completed.where("student_id = ?", session["user_id"]) # Суралцагчийн үзсэн бүх хичээл
        @viewed.each do |less| # Одоогийн бүлгээс үзсэн хичээл
          if Lesson.find(less.lesson_id).chapter_id == @ch_id
            @viewed_lesson += 1
          end
        end
      end

      #---------- Дараагийн хичээл-----------
      if not Lesson.where("id > ? and chapter_id = ?", session["lesson_id"], @ch_id).blank?
        session["lesson_id"] = Lesson.where("id > ? and chapter_id = ?", session["lesson_id"], @ch_id).first.id

      elsif not Chapter.where("id > ?", @ch_id).blank?
        @ch_id1 = Chapter.where("id > ?", @ch_id).order("id").first.id


        while Chapter.find(@ch_id1).lessons.count == 0 do # Тухайн бүлэгт харгалзах хичээл байхгүй
          if not Chapter.where("id > ?", @ch_id1).blank?  # Дараагийн бүлэг байгаа эсэхийг шалгана
            @ch_id1 = Chapter.where("id > ?", @ch_id1).first.id # Дараагийн бүлгийн id - г авна
          else # Дараагийн бүлэг байхгүй бол
            @finish = true
            break
          end
        end

        # Дараагийн бүлгээс эхний хичээлийг уншиж байна
        if @finish == false
          session["lesson_id"] = Lesson.where("chapter_id = ?", @ch_id1).order("id").first.id
        end
      else
        @finish = true
      end

    elsif params[:check]
      
      @next = false
      if params[:lesson][:code].blank?  # Хоосол бол програм ажиллаж болохгүй
        
      else
        @code = params[:lesson][:code] # Суралцагчийн бичсэн кодыг авна
        @id = params[:lesson][:id] # Хичээлийн id

        # -----------------------Зөв код------------------------------
        File.open("C:/Users/Tsoo/Documents/google.txt", "w+") do |f|
          f.write(@code)
        end
        @student_answer = Interpreters.new("C:/Users/Tsoo/Documents/google.txt")
        @student_answer.program_runner()
        @student_declar = @student_answer.parser.declarations
        @student_condition = @student_answer.conditions

        if @student_answer.error.blank?
          @error = false
          @student_print = @student_answer.print
        else
          @error = true
          @student_print = @student_answer.error
        end

        # -----------------------Суралцагчийн код------------------------------
        @incorrect_id = -1 # Буруу хийсэн зааврын id-г агуулна
        @filled = Array.new # Зөв хийгдсэн зааврыг хадгална

        @instructions.each do |i| # Даалгавар бүрийг давтана
          File.open("C:/Users/Tsoo/Documents/answer.txt", "w+") do |f|
            f.write(i.answer)
          end
          @command = Interpreters.new("C:/Users/Tsoo/Documents/answer.txt")
          @command.program_runner()
          @command_condition = @command.conditions
          @command_declar = @command.parser.declarations
          @command_print = @command.print
          

          if i.statement == 1 # Хувьсагчийн зарлагаа
            check_declaration 
          elsif i.statement == 2 # Утга олгох
            check_assignment
          elsif i.statement == 3 # if нөхцөл шалгах
            check_condition
          elsif i.statement == 4 # switch нөхцөл шалгах

          elsif i.statement == 5 # For давталт
            check_for
          elsif i.statement == 6 # while давталт

          elsif i.statement == 7 # do while давталт

          elsif i.statement == 8 # метод функц

          elsif i.statement == 9 # class класс
            
          elsif i.statement == 10 # Console хэвлэх үр дүн шалгах
            check_output
          elsif i.statement == 11 # Хоосон шалгагахгүй
            @is_true = true
          else

          end

          if not @is_true
            @incorrect_id = i.id
            break
          else
            @filled.push(i.id) # Зөв хийгдсэн зааврыг хадгална
          end

        end

        respond_to do |format|
          format.html { redirect_to :lesson }
          format.js
        end

      end
    end
  end


  def check_declaration
    @is_true = true # Бүх хувьсагчийг зөв зарласан эсэхийг шалгана
    @check = false
    @command_declar.each do |core|  # Нэг заавар дотор хувьсагч зарлагдсан эсэхийг шалгана
      @student_declar.each do |dec|
        if dec.var_name == core.var_name and dec.var_type == core.var_type
          @check = true
        end
      end
      if @check == false
        @notfound_var = core.var_name
        @notfound_type = core.var_type
        @is_true = false
        break
      else
        @is_true = true
      end
    end
  end

  def check_assignment  # Утга олголт зөв эсэхийг шалгана
    @is_true = true
    @is_exist = false

    @command_declar.each do |com|
      @student_declar.each do |dec|
        if com.expression.is_a? Expression
          com.expression = @command.expression(com.expression)
        end
        if dec.expression.is_a? Expression
          dec.expression = @student_answer.expression(dec.expression)
        end

        if com.var_name == dec.var_name
          if com.expression != dec.expression
            @is_true = false
            break
          end
          @is_exist = true
        end
      end
      if @is_exist == false
        @is_true = false
        break
      end
    end
  end

  def check_condition
    @is_true = false

    @command_condition.each_with_index{|item, index|
      if @command_condition[index] == @student_condition[index]
        @is_true = true
      else
        @is_true = false
        break
      end
    }
    @student_condition = @student_condition - @command_condition

  end

  def check_output  # Гаралт зөв эсэхийг шалгана
    @is_true = false
    @command_print.each_with_index{|item, index|
      if @command_print[index] == @student_print[index]
        @is_true = true
      else
        @is_true = false
        break
      end
    }
  end

  def check_for
    if @student_answer.for_initial == @command.for_initial and @student_answer.for_finish  == @command.for_finish and @student_answer.for_step == @command.for_step
      @is_true = true
    else
      @is_true = false
    end
  end




  def show_chapter
    session["chapter_id"] = params[:id]
    redirect_to :show_chapter_lessons

  end

  def show_chapter_lessons
    student_info
    @chapter = Chapter.find(session["chapter_id"])
    
  end


  def new_instruction
    @instuction = Instruction.new
  end
  
  def create_instruction
    @instuction = Instruction.new(instruction_params)
    respond_to do |format|
      if @instuction.save
        format.html{ redirect_to :lessonshow, notice: "Таныг амжилттай бүртгэлээ :)" }
        format.json{ render action: "create", status: :created, location: @instuction}
        format.js{ render action: "create", status: :created, location: @instuction }
      else
        format.html{ render action: "new_instruction" }
        format.json{ render json: @instuction.errors, status: :unprocessable_entity }
        format.json{ render json: @instuction.errors, status: :unprocessable_entity }
      end
    end
  end

  def show_lesson
    session["lesson_id"] = params[:id]
    redirect_to :lessonindex
  end

  def update
    @lesson = Lesson.find(params[:id])
  end

  def edit
    @lesson = Lesson.find(params[:id])
    if @lesson.update_attributes(lesson_params)
      flash[:success] = "Хичээл засагдлаа"
      redirect_to :lessonshow
    else
      render action: "update"
    end
  end

  def destroy
    all_lesson
    Lesson.find(params[:id]).destroy
    flash[:success] = "Хичээл устгагдлаа"
    render :show
  end

  def chapter # Хичээлийн агуулгыг суралцагчид харуулна
    student_info
    @chapter = Chapter.all

    @id_count = Array.new
    @chapter.each do |t|
      @id_count.push(t.id)
    end

    @chapter_lessons_count = 0
    @student_lesson_count = Completed.where("student_id = ?",  session["user_id"]).count # Суралцагчийн үзсэн хичээлийн тоо
    
    if @student_lesson_count == 0 # Анхны хичээл
      @first_chapter_id = Chapter.first.id
      @first_lesson = Lesson.where("chapter_id = ?", @first_chapter_id).order("id").first.id
      Completed.new(:take_score => 0 , :isview => 1, :student_id => session["user_id"], :lesson_id => @first_lesson).save
    end
    
    @uncomp = false
    @completed = Array.new # СУралцагчийн үзсэн бүлгийг хадгалах массив
    @uncompleted = Array.new # СУралцагчийн үзээгүй бүлгийг хадгалах массив

    @last_lesson_id = Completed.where("student_id = ?", session["user_id"]).order("id desc").first.lesson_id # Хамгийн сүүлд хийж дуусгасан хичээлийн id
    @lli_chapter_id = Lesson.find(@last_lesson_id).chapter_id # Сүүлд үзсэн хичээлийн chapter id
    @fin = false


    if @student_lesson_count != 0
      # Хамгийн сүүлд үзсэн хичээлээс дараагийн хичээлийг уншина
      if not Lesson.where("id > ? and chapter_id = ?", @last_lesson_id, @lli_chapter_id).blank?
          session["lesson_id"] = Lesson.where("id > ? and chapter_id = ?", @last_lesson_id, @lli_chapter_id).first.id

      elsif not Chapter.where("id > ?", @lli_chapter_id).blank?
        @ch_id1 = Chapter.where("id > ?", @lli_chapter_id).order("id").first.id

        while Chapter.find(@ch_id1).lessons.count == 0 do # Тухайн бүлэгт харгалзах хичээл байхгүй
          if not Chapter.where("id > ?", @ch_id1).blank?  # Дараагийн бүлэг байгаа эсэхийг шалгана
            @ch_id1 = Chapter.where("id > ?", @ch_id1).first.id # Дараагийн бүлгийн id - г авна
          else # Дараагийн бүлэг байхгүй бол
            @fin = true
            session["lesson_id"] = @last_lesson_id
            break
          end
        end
        # Дараагийн бүлгээс эхний хичээлийг уншиж байна
        if @fin == false
          session["lesson_id"] = Lesson.where("chapter_id = ?", @ch_id1).order("id").first.id
        end
      else
        session["lesson_id"] = @last_lesson_id
      end
    else
      session["lesson_id"] = @last_lesson_id
    end

    @chapter.each do |chapter|  
      @count = Lesson.where("chapter_id = ?", chapter.id).count # Бүлэг дотор хичээлийн тоо

      #if @count == 0  # Хичээлгүй бүлэг эсэхийг шалгана. 
      #  next
      #end
      
      if @uncomp == true
        @uncompleted << chapter
        next
      end

      @chapter_lessons_count += @count # бүлэг доторх хичээлийн тоог нийт хичээлийн тоо болгож нэмнэ
      if @chapter_lessons_count > @student_lesson_count
        @notdo_lessons = @chapter_lessons_count - @student_lesson_count
        @chapter_lessons_count = @count # Суралцагчийн гүйцээгүй гэхдээ гүйцээж байгаа бүлгийн хичээлийн тоо
        
        @do_chapter = chapter
        @uncomp = true
      else
        @completed << chapter
      end
    end
  end

  def show
    all_lesson
    
  end

  def new
  end

  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html{ redirect_to :lessonshow, notice: "Таныг амжилттай бүртгэлээ :)" }
        format.json{ render action: "create", status: :created, location: @lesson}
        format.js{ render action: "create", status: :created, location: @lesson }
      else
        format.html{ render action: "new" }
        format.json{ render json: @lesson.errors, status: :unprocessable_entity }
        format.json{ render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def logout
    session["user_id"] = nil
    @student_info = nil

    redirect_to :index
  end

  private 
    def student_info
      @student_info = Student.find(session["user_id"])
      if @student_info.picture.blank?
        @image = "/assets/default_75.png"
      else
        @image = @student_info.picture
      end
    end
    def new_lesson
      @lesson = Lesson.new
    end
    def lesson_params
      params.require(:lesson).permit(:name, :theory, :theory_example, :instruction, :answer, :code, :score, :sub_score, :is_exercise, :chapter_id, :organizer_id)
    end
    def all_lesson
      @lessons = Lesson.where(is_exercise: 0).all
    end
    def instruction_params
      params.require(:instruction).permit(:command, :example, :answer, :statement, :lesson_id)
    end
end
