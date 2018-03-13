class Lexer

	def initialize()
		@row = 0
		@column = 0
		@program_lines = Array.new
		@keywords = Array.[]("тогтмол", "алгасах", "сонголт", "зогс", "төрөл", "нөхцөл", "return", "for",
                "class", "void", "анхны", "if", "static", "while", "do", "print",
                "elseif", "else", "оруулах", "Console", "switch", "case", "break", "default", "public",
                "private", "protected")
	end
	def row
		return @row
	end
	def column
		return @column
	end
	def read_char(row, column)
		return @program_lines[row][column]
	end
	
	def next_char()

		begin
			@length = @program_lines[@row].length
		rescue
			return '~'
		end

		if(@column >= @length)
			@row += 1
			@column = 0
			if(@length == 0)
				return ' '
			end
		elsif(read_char(@row, @column) == '~')
			return '~'
		end
		@value = read_char(@row, @column)
		@column += 1

		return @value.to_s
	end

	def next_token()
		one_char = next_char()

		while whitespace(one_char) == true do
			one_char = next_char
		end

		if(one_char == '~')
			return Token.new("EOF", "~")
		end

		if(one_char == "/") # Нэг мөрийн comment
			ch = next_char()
			if ch == "/"
				while not one_char.eql?("\n") do
					one_char = next_char()
				end
			else
				@column -= 1
			end
		end

		if(one_char == ".")
			return Token.new("DOT", one_char)
		end

		if one_char == "+"
			ch = next_char()
			if ch == "="
				return Token.new("Assignment", "+=")
			elsif ch == "+"
				return Token.new("Assignment", "++")
			else
				@column -= 1
				return Token.new("Operator", one_char)
			end
		elsif one_char == "-"
			ch = next_char()
			if ch == "="
				return Token.new("Assignment", "-=")
			elsif ch == "-"
				return Token.new("Assignment", "--")
			else
				@column -= 1
				return Token.new("Operator", one_char)
			end
		elsif one_char == "*" or one_char == "/" or one_char == "%"
			return Token.new("Operator", one_char)

		elsif is_letter(one_char)
			@word = one_char
			@word += concat_char()

			for key in @keywords
				if(key == @word)
					return Token.new("Keyword", @word)
				end
			end

			if @word == "char"
				return Token.new("Type", "Char")
			elsif @word == "String"
				return Token.new("Type", "String")
			elsif @word == "double"
				return Token.new("Type", "Double")
			elsif @word == "int"
				return Token.new("Type", "Int")
			elsif @word == "boolean" or @word == "bool"
				return Token.new("Type", "Boolean")
			elsif @word == "float"
				return Token.new("Type", "Float")
			elsif @word == "true" or @word == "false"
				return Token.new("Boolean", @word)
			elsif @word == "Функц" or @word == "функц"
				return Token.new("Header", @word)
			elsif @word == "print"
				return Token.new("Print", @word)
			elsif @word == "WriteLine"
				return Token.new("WriteLine", @word)
			end

			return Token.new("Identifier", @word)

		elsif is_number(one_char)
			@word = one_char
			@word += concat_number()

			if @word.include? "."
				return Token.new("Double", @word)
			else
				return Token.new("Int", @word)
			end

		elsif one_char == "'"
			ch = next_char()
			chs = ""
			while ch != "'" do
				chs += ch
				ch = next_char()
			end
			return Token.new("Char", chs)
		
		elsif one_char == ":"
			return Token.new("Colon", one_char)
		elsif one_char == "\""
			wd = next_char()
			wds = ""
			while wd != "\"" do
				wds += wd
				wd = next_char()
			end
			return Token.new("String", wds)

		elsif one_char == "\n"
			return Token.new("Newline", "Шинэ мөр")
		elsif one_char == ","
			return Token.new("Comma", one_char)
		elsif one_char == "="
			one_char = next_char()
			if one_char == "="
				return Token.new("Equals", "==")
			else
				@column -= 1
				return Token.new("Assignment", "=")
			end
		elsif one_char == "!"
			one_char = next_char()
			if one_char == "="
				return Token.new("NotEqual", "!=")
			else
				@column -= 1
				return Token.new("Not", "!")
			end
		elsif one_char == ">"
			one_char = next_char()
			if one_char == "="
				return Token.new("Compare", ">=")
			else
				@column -= 1
				return Token.new("Compare", ">")
			end
		elsif one_char == "<"
			one_char = next_char()
			if one_char == "="
				return Token.new("Compare", "<=")
			else
				@column -= 1
				return Token.new("Compare", "<")
			end
		elsif one_char == "{"
			return Token.new("LEFTBRACE", one_char)
		elsif one_char == "}"
			return Token.new("RIGHTBRACE", one_char)
		elsif one_char == "("
			return Token.new("Left_Paren", one_char)
		elsif one_char == ")"
			return Token.new("Right_Paren", one_char)
		elsif one_char == "|"
			one_char = next_char()
			if one_char == "|"
				return Token.new("OR", "||")
			else
				@column -= 1
				return Token.new("Special", "|")
			end
		elsif one_char == "&"
			one_char = next_char()
			if one_char == "&"
				return Token.new("AND", "&&")
			else
				@column -= 1
				return Token.new("Special", "&")
			end
		elsif one_char == ";"
			return Token.new("Semicolon", one_char)
		elsif is_special(one_char)
			return Token.new("Special", one_char)
		else
			return Token.new("Any", one_char)
		end
	end

	def concat_char()
		@w = ''
		while true do
			@str = next_char()
			if(is_letter(@str) or is_number(@str) or @str == "_")
				@w += @str
			else
				@column -= 1
				break
			end
		end
		return @w
	end

	def concat_number()
		@w = ''
		while true do
			@str = next_char()
			if(is_number(@str) or @str == ".")
				@w += @str
			else
				@column -= 1
				break
			end
		end
		return @w
	end

	def is_special(one_char)
		if(/[!#$'()*+,\.\/<=>?@\^_`{|}-]/.match(one_char))
			return true
		else
			return false
		end
	end

	def whitespace(one_char)
		if (/[ \t\r\v\f]/.match(one_char))
			return true
		else
			return false
		end
	end

	def is_letter(one_char)
		if(/[АБВГДЕЁЖЗИЙКЛМНОӨПРСТУҮФХЦЧШЩЫЬЭЮЯабвгдеёжзийклмноөпрстуүфхцчшщыьэюяa-zA-Z]/.match(one_char))
			return true
		else
			return false
		end
	end

	def is_number(one_char)
		if(/[0-9]/.match(one_char))
			return true
		else
			return false
		end
	end

	def set_file_to_array(path)
		begin
			file = File.open(path) or die("Файл нээж чаддагүй хэхэ")

			file.each_line {|line|
				@program_lines.push(line)
			}
			@program_lines.push("\n")
			@program_lines.push("~")

			return true
		rescue
			return false
		end
	end

	def get_file()
		return @program_lines
	end
end


class Token
	@type = ""
	@value = ""

	def initialize(type, value)
		@type = type
		@value = value
	end
	def type()
		return @type
	end
	def value()
		return @value
	end
	def to_s
		return @type+' '+@value
	end
end