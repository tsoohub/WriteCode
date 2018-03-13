class Parser
	attr_accessor :parser_error
	attr_accessor :declarations
	
	def initialize(lexem)
		@main = nil
		@stack = Array.new
		@classes = Array.new
		@declars = Array.new
		@functions = Array.new
		@error_list = Array.new
		@declarations = Array.new
		@parser_error = false
		@assignment_term = nil

		@lexer = lexem
		@current_token = @lexer.next_token()
	end
	def current_token()
		return @current_token
	end
	def parser_error
		return @parser_error
	end
	def declarations()
		return @declarations
	end
	def functions()
		return @functions
	end
	def error_list()
		return @error_list
	end
	def main()
		return @main
	end
	def stack()
		return @stack
	end

	def match(token, error_message=nil, row=nil)	# Одоогийн токены төрөл нь орж ирсэн токены төрөлтэй тэнцүү эсэхийг шалгана
		value = @current_token.value

		if @current_token.type == token.type
			@current_token = @lexer.next_token
		else
			if @current_token.type == TokenType.EOF.type
				return
			end
			@error_list.push("Мөр: " + (row+1).to_s + " синтакс алдаа:\n"+ token.value + "  " +error_message)
			@current_token = TokenType.EOF
			@parser_error = true
			return
		end
		return value
	end

	def match_value(token, error_message=nil, row=nil)	# Одоогийн токены утга нь орж ирсэн токены утгатай тэнцүү эсэхийг шалгана
		value = @current_token.value

		if @current_token.value == token.value
			@current_token = @lexer.next_token
		else
			if @current_token.type == TokenType.EOF.type
				return
			end
			@error_list.push("Мөр: " + (row+1).to_s + " синтакс алдаа:\n"+ token.value + "  " +error_message)
			@current_token = TokenType.EOF
			@parser_error = true
			return
		end
		return value
	end

	def expression()
		if @current_token.type == TokenType.EOF.type
			return
		end
		term1 = conjunction()
		while @current_token.type == TokenType.OR.type do
			op = Operator.new(@current_token.value)
			@current_token = @lexer.next_token()
			term2 = conjunction()
			term1 = Binary.new(op, term1, term2)
		end
		return term1
	end

	def conjunction()
		if @current_token.type == TokenType.EOF.type
			return
		end
		term1 = equality()
		while @current_token.type == TokenType.AND.type do
			op = Operator.new(@current_token.value)
			@current_token = @lexer.next_token()
			term2 = equality()
			term1 = Binary.new(op, term1, term2)
		end
		return term1
	end

	def equality()
		if @current_token.type == TokenType.EOF.type
			return
		end
		term1 = relation()
		while @current_token.type == TokenType.EQUALS.type or @current_token.type == TokenType.NOTEQ.type do
			op = Operator.new(@current_token.value)
			@current_token = @lexer.next_token()
			term2 = relation()
			term1 = Binary.new(op, term1, term2)
		end
		return term1
	end

	def relation()
		if @current_token.type == TokenType.EOF.type
			return
		end
		term1 = addition()
		while @current_token.type == TokenType.COMPARE.type or @current_token.value == "++" or @current_token.value == "--" or @current_token.value == "+=" or @current_token.value == "-=" do
			op = Operator.new(@current_token.value)
			if @current_token.value == "++" or @current_token.value == "--"	# Утга олгох үйлдлийн operator эсэхийг шалгана
				term2 = IntValue.new(1)
				@current_token = @lexer.next_token()
			elsif @current_token.value == "+=" or @current_token.value == "-="
				@current_token = @lexer.next_token()
				term2 = addition()
			else
				@current_token = @lexer.next_token()
				term2 = addition()
			end
			term1 = Binary.new(op, term1, term2)
			
		end
		return term1
	end

	def addition()
		if @current_token.type == TokenType.EOF.type
			return
		end
		term1 = term()
		while @current_token.value == TokenType.ADD.value or @current_token.value == TokenType.SUB.value do
			op = Operator.new(@current_token.value)
			@current_token = @lexer.next_token()
			term2 = addition()
			term1 = Binary.new(op, term1, term2)
		end
		return term1
	end

	def term()
		if @current_token.type == TokenType.EOF.type
			return
		end
		term1 = factor()
		while @current_token.value == TokenType.MUL.value or @current_token.value == TokenType.DIV.value or @current_token.value == TokenType.PER.value do
			op = Operator.new(@current_token.value)
			@current_token = @lexer.next_token()
			term2 = factor()
			term1 = Binary.new(op, term1, term2)
		end
		return term1
	end

	def factor()
		if @current_token.type == TokenType.EOF.type
			return
		end
		
		if @current_token.value == "++" or @current_token.value == "--" or @current_token.value == "+=" or @current_token.value == "-="
			@term1 = @assignment_term	# Утга олгох үйлдэл бөгөөд assignment_term нь утга олгох хувьсагчийн нэр түүнийг буцаана
			return @term1
		end

		if @current_token.type == TokenType.NOT.type or @current_token.type == TokenType.MINUS.type
			op = Operator.new(@current_token.value)
			@current_token = @lexer.next_token()
			term1 = primary()
			return Unary.new(op, term1)
		else
			return primary()
		end
	end

	def primary()
		if @current_token.type == TokenType.EOF.type
			return
		end
		term1 = nil

		if @current_token.type == TokenType.IDENTIFIER.type
			term1 = Variable.new(@current_token.value)
			@current_token = @lexer.next_token()
			if @current_token.type == TokenType.LEFTPARET
				term1 = call(term1)
			end
		elsif is_literal
			term1 = literal()
		elsif @current_token.type == TokenType.LEFTPARET.type
			@current_token = @lexer.next_token
			term1 = expression()
			match(TokenType.RIGHTPARET, " баруу хаалт ')' ", @lexer.row)
		else
			if @current_token.type == TokenType.EOF.type
				return
			end
			@error_list.push("Мөр: "+ (@lexer.row+1).to_s + ", синтакс алдаа алдаатай илэрхийлэл "+@current_token.value)
			@current_token = TokenType.EOF
			@parser_error = true
			return
		end

		return term1
	end

	def literal()
		if @current_token.type == TokenType.EOF.type
			return
		end

		case @current_token.type
			when TokenType.INT.type
				value = match(TokenType.INT, " int төрлийн утга авах ёстой", @lexer.row)
				return IntValue.new(value.to_i)
			when TokenType.DOUBLE.type
				value = match(TokenType.DOUBLE, " double төрлийн утга авах ёстой", @lexer.row)
				return DoubleValue.new(value.to_f)
			when TokenType.CHAR.type
				value = match(TokenType.CHAR, " char төрлийн утга авах ёстой", @lexer.row)
				return CharValue.new(value.to_s)
			when TokenType.STRING.type
				value = match(TokenType.STRING, " String төрлийн утга авах ёстой", @lexer.row)
				return StringValue.new(value.to_s)
			when TokenType.BOOL.type
				value = match(TokenType.BOOL, " boolean төрлийн утга авах ёстой", @lexer.row)
				return BoolValue.new(value)
			when TokenType.FLOAT.type
				value = match(TokenType.FLOAT, " float төрлийн утга авах ёстой", @lexer.row)
				return FloatValue.new(value)
			else
				@error_list.push("Мөр: "+ row.to_s + ", төрөл хөрвүүлэлтийн алдаа: " +@current_token.value+" буруу төрөл")
				@current_token = TokenType.EOF
				@parser_error = true
				return
		end 
	end

	def is_literal()
		case @current_token.type
			when TokenType.INT.type, 
				 TokenType.DOUBLE.type,
				 TokenType.STRING.type,
				 TokenType.CHAR.type,
				 TokenType.BOOL.type,
				 TokenType.FLOAT.type
				return true
			else
				return false
		end
	end

	def is_type()
		if @current_token.type == TokenType.TYPE.type
			return true
		else
			return false
		end
	end
	def program()
		while @current_token.type == TokenType.EOF.type do
			if is_type()
				process_declaration()
			elsif @current_token.value == TokenType.HEADER.value
				function()
			elsif @current_token.type == TokenType.NEWLINE.type
				@current_token = @lexer.next_token()
			else
				@error_list.push("Мөр: "+ @token.row.to_s + ", програмд таарахгүй стэйтмэнт олдлоо  "+token.value)
				@current_token = TokenType.EOF
				@parser_error = true
			end
		end
	end
	def call(name)
		if @current_token.type == TokenType.EOF.type
			return
		end
		match(TokenType.LEFTPARET, " функцын зүүн хаалт дутуу ", @lexer.row)
		arguments = Array.new
		if @current_token.type != TokenType.RIGHTPARET.type
			arguments.push(expression())
			while @current_token.type == TokenType.COMMA.type do
				@current_token = @lexer.next_token()
				arguments.push(expression())
			end
		end
		match(TokenType.RIGHTPARET, " функцын баруун хаалт дутуу", @lexer.row)
		match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)

		return Call.new(name, arguments)
	end
	def process_header()
		match(TokenType.LEFTPARET, " зүүн дугуй хаалтаар эхлэнэ ", @lexer.row)
		match(TokenType.RIGHTPARET, " баруун дугуй хаалтаар төгсөнө ", @lexer.row)
	end
	def print_(express)
		if @current_token.type == TokenType.EOF.type
			return
		end
		if @current_token.type == TokenType.COMMA.type
			@current_token = @lexer.next_token()
			real_expression = expression()
			return print_(Print.new(real_expression, express))
		else
			return express
		end
	end

	def process_declaration()
		if @current_token.type == TokenType.EOF.type
			return
		end
		@declars = Array.new
		while is_type() do
			var_declar()
			@current_token = @lexer.next_token()
		end
		return @declars
	end

	def var_declar()
		if @current_token.type == TokenType.EOF.type
			return
		end
		declar_type = @current_token.value
		initial = nil

		while @current_token.type != TokenType.SEMICOLON.type do # @current_token.type != TokenType.NEWLINE.type and 
			@current_token = @lexer.next_token()
			var_name = match(TokenType.IDENTIFIER, " хувьсагчийн нэрлэлт алдаатай ", @lexer.row)

			if @current_token.type == TokenType.ASSIGN.type
				@current_token = @lexer.next_token()
				initial = expression()
			end
			if @stack.length == 0
				@declarations.push(Declaration.new(var_name, declar_type, @stack.length, initial))
			else
				@declars.push(Declaration.new(var_name, declar_type, @stack.length, initial))
			end
		end
		match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)
	end

	def assignment(variable_name)
		if @current_token.type == TokenType.EOF.type
			return
		end
		target = Variable.new(variable_name)

		if @current_token.value == "="
			@current_token = @lexer.next_token()
			if @current_token.value == TokenType.INPUT.value # Гараас утга оруулах тэмдэгт мөн эсэхийг шалгана
				@current_token = @lexer.next_token()
				source = TokenType.INPUT
			else # Энгийн илэрхийлэл болно
				source = expression()
			end
		elsif @current_token.value == "++" or @current_token.value == "--" or @current_token.value == "+=" or @current_token.value == "-="
			@assignment_term = target
			source = expression()
		else # Алдаа
			if @current_token.type == TokenType.EOF.type
				return
			end
			@error_list.push("Мөр: "+ (@lexer.row+1).to_s + " синтакс алдаа: Утга олголт буруу")
			@current_token = TokenType.EOF
			@parser_error = true
			return
		end

		match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)
		return Assignment.new(target, source)
	end

	def while_statement()
		if @current_token.type == TokenType.EOF.type
			return
		end
		@current_token = @lexer.next_token()
		match(TokenType.LEFTPARET, " while зүүн дугуй хаалт дутуу ", @lexer.row)
		condition = expression()
		match(TokenType.RIGHTPARET, " while баруун дугуй хаалт дутуу ", @lexer.row)

		skip_newline()

		body = statement()
		return Loop.new(condition, body)
	end

	def dowhile_statement()
		if @current_token.type == TokenType.EOF.type
			return
		end
		@current_token = @lexer.next_token()
		skip_newline()
		body = statement()

		match(TokenType.DOWHILE, " do түлхүүр үг байна ", @lexer.row)
		match(TokenType.LEFTPARET, "do while зүүн дугуй хаалт дутуу ", @lexer.row)
		test = expression()
		match(TokenType.RIGHTPARET, "do while баруун дугуй хаалт дутуу ", @lexer.row)
		match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)
		
		return Loop.new(test, body, true)
	end

	def For()
		if @current_token.type == TokenType.EOF.type
			return
		end
		@current_token = @lexer.next_token()
		match(TokenType.LEFTPARET, "for зүүн дугуй хаалт дутуу ", @lexer.row)
		initial = nil

		if @current_token.type == TokenType.IDENTIFIER.type
			initial = assignment(match(TokenType.IDENTIFIER, " хувьсагчийн нэр буруу байна ", @lexer.row))
		elsif is_type()
			declar_type = @current_token.value
			@current_token = @lexer.next_token()
			var_name = match(TokenType.IDENTIFIER, " хувьсагчийн нэр буруу байна ", @lexer.row)
			match(TokenType.ASSIGN, " утга олголт буруу ", @lexer.row)
			exp = addition()
			initial = Declaration.new(var_name, declar_type, @stack.length, exp)
			match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)
		else
			if @current_token.type == TokenType.EOF.type
				return
			end
			@error_list.push("Мөр: "+ @lexer.row.to_s + ", синтакс алдаа  " +" For хувьсагчийн зарлагаа эсвэл утга олгох буруу "+@current_token.value)
			@current_token = TokenType.EOF
			@parser_error = true
		end
		condition = relation()
		match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)

		# Хувьсагч утга олгох хэсэг буюу assignment. Assignment-ийн дараа semicolon байхгүй учир тусдан бичив
		target = Variable.new(match(TokenType.IDENTIFIER, " For хувьсагчийн нэр буруу ", @lexer.row))
		if @current_token.value == "="
			@current_token = @lexer.next_token()
			source = expression()
		elsif @current_token.value == "++" or @current_token.value == "--" or @current_token.value == "+=" or @current_token.value == "-="
			@assignment_term = target
			source = expression()
		else # Алдаа
			if @current_token.type == TokenType.EOF.type
				return
			end
			@error_list.push("Мөр: "+ (@lexer.row+1).to_s + " For синтакс алдаа: утга олголт буруу")
			@current_token = TokenType.EOF
			@parser_error = true
			return
		end
		increment = Assignment.new(target, source)

		match(TokenType.RIGHTPARET, " for баруун дугуй хаалт дутуу ", @lexer.row)
		skip_newline()
		statement = statement()
		return For.new(initial, condition, increment, statement)
	end

	def if_statement()
		if @current_token.type == TokenType.EOF.type
			return
		end
		@current_token = @lexer.next_token()
		match(TokenType.LEFTPARET, " if зүүн дугуй хаалт дутуу ", @lexer.row)
		test = expression()
		match(TokenType.RIGHTPARET, " if баруун дугуй хаалт дутуу ", @lexer.row)
		skip_newline()
		statement = statement()
		skip_newline()

		if @current_token.value == TokenType.ELSEIF.value
			return elif_statement(test, statement, nil)
		end
		if @current_token.value == TokenType.ELSE.value
			@current_token = @lexer.next_token()
			return Condition.new(test, statement, nil, statement())
		end
		return Condition.new(test, statement)
	end

	def elif_statement(test, statement, el_statement)
		if @current_token.type == TokenType.EOF.type
			return
		end
		@current_token = @lexer.next_token()
		match(TokenType.LEFTPARET, " elseif зүүн дугуй хаалт дутуу", @lexer.row)
		elif_test = expression()
		match(TokenType.RIGHTPARET, " elseif баруун дугуй хаалт дутуу ", @lexer.row)
		skip_newline()
		elif_statement = statement()
		skip_newline()

		if @current_token.value == TokenType.ELSEIF.value
			return Condition.new(test, statement, elif_statement(elif_test, elif_statement, nil))
		elsif @current_token.value == TokenType.ELSE.value
			@current_token = @lexer.next_token()
			return Condition.new(test, statement, Condition.new(elif_test, elif_statement, nil, statement() ))
		end

		return Condition.new(test, statement, Condition.new(elif_test, elif_statement))
	end

	def switch()
		if @current_token.type == TokenType.EOF.type
			return
		end
		@current_token = @lexer.next_token()
		match(TokenType.LEFTPARET, " switch нээх хаалт дутуу ", @lexer.row+1)
		switchExpression = expression()
		match(TokenType.RIGHTPARET, " switch хаах хаалт дутуу ", @lexer.row+1)
		skip_newline()
		match(TokenType.LEFTBRACE, " switch зүүн хаалт дутуу ", @lexer.row+1)
		skip_newline()
		

		match_value(TokenType.CASE, " case түлхүүр үг дутуу ", @lexer.row+1)
		primary = primary() # Хувьсагч эсвэл Энгийн төрөл бүхий утга
		match(TokenType.COLON, " : тэмдэгт дутуу ", @lexer.row+1)
		block = Block.new
		while @current_token.value != "break"
			if @current_token.type == TokenType.EOF.type
				return
			end
			block.members.push(statement())
		end
		@current_token = @lexer.next_token()
		match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row+1)
		skip_newline()

		# case - боловсруулалт
		if @current_token.value == TokenType.CASE.value # Дараа нь case байгаа эсэхийг шалгана
			return Switch.new(switchExpression, switch_case(primary, block))

		# default- боловсруулалт
		elsif @current_token.value == TokenType.DEFAULT.value
			@current_token = @lexer.next_token()
			match(TokenType.COLON, " : тэмдэгт дутуу ", @lexer.row+1)
			d_block = Block.new
			while @current_token.value != "break"
				if @current_token.type == TokenType.EOF.type
					return
				end
				d_block.members.push(statement())
			end
			@current_token = @lexer.next_token()
			match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row+1)
			skip_newline()
			match(TokenType.RIGHTBRACE, " switch хаах хаалт дутуу ", @lexer.row+1)
			return Switch.new(switchExpression, Condition.new(primary, block, nil, d_block))

		else # Only нэг case
			match(TokenType.RIGHTBRACE, " switch хаах хаалт дутуу ", @lexer.row+1)		
			return Switch.new(switchExpression, Condition.new(primary, block))
		end

	end

	def switch_case(case1, stmnt)

		@current_token = @lexer.next_token()
		primary = primary() # Хувьсагч эсвэл Энгийн төрөл бүхий утга
		match(TokenType.COLON, " : тэмдэгт дутуу ", @lexer.row+1)
		block = Block.new
		while @current_token.value != "break"
			if @current_token.type == TokenType.EOF.type
				return
			end
			block.members.push(statement())
		end
		@current_token = @lexer.next_token()
		match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row+1)
		skip_newline()

		if @current_token.value == TokenType.CASE.value
			return Condition.new(case1, stmnt, switch_case(primary, block))
		elsif @current_token.value == TokenType.DEFAULT.value
			@current_token = @lexer.next_token()
			match(TokenType.COLON, " : тэмдэгт дутуу ", @lexer.row+1)
			d_block = Block.new
			while @current_token.value != "break"
				if @current_token.type == TokenType.EOF.type
					return
				end
				d_block.members.push(statement())
			end
			@current_token = @lexer.next_token()
			match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row+1)
			skip_newline()
			match(TokenType.RIGHTBRACE, " switch хаах хаалт дутуу ", @lexer.row+1)
			return Condition.new(case1, stmnt, Condition.new(primary, block, nil, d_block))
			
		else
			match(TokenType.RIGHTBRACE, " switch хаах хаалт дутуу ", @lexer.row+1)	
			return Condition.new(case1, stmnt, Condition.new(primary, block))
		end

	end

	def function()
		if @current_token.type == TokenType.EOF.type
			return
		end
		parameters = Array.new
		return_type = nil # ФУнкын буцаах утга

		if is_type() or @current_token.value == TokenType.VOID.value
			return_type = @current_token.value
			@current_token = @lexer.next_token()
		else # Алдаа гарсан
			match(TokenType.TYPE, " функцын зарлагаа буруу ", @lexer.row)
		end

		if(@current_token.type == TokenType.IDENTIFIER.type)
			f_name = match(TokenType.IDENTIFIER, " функцын нэр буруу ", @lexer.row)
			match(TokenType.LEFTPARET, " функцын зүүн дугуй дутуу ", @lexer.row)

			if is_type()	# Функцийн параметрийн төрөл
				param_type = match(TokenType.TYPE, " параметрийн төрөл буруу ", @lexer.row)
				param_name = match(TokenType.IDENTIFIER, " параметрийн нэр буруу ", @lexer.row)

				parameters.push(Declaration.new(param_name, param_type, @stack.length + 1))
				while @current_token.type == TokenType.COMMA.type do
					@current_token = @lexer.next_token()
					param_type = match(TokenType.TYPE, " параметрийн төрөл буруу ", @lexer.row)
					param_name = match(TokenType.IDENTIFIER, " параметрийн нэр буруу ", @lexer.row)
					parameters.push(Declaration.new(param_name, param_type, @stack.length + 1))
				end
			end
			match(TokenType.RIGHTPARET, " функцын баруун дугуй хаалт дутуу ", @lexer.row)
			skip_newline()
			body = statement()
			@functions.push(Function.new(f_name, body, parameters))
		else
			process_header()
			statement = statement()
			@main = Function.new("Main", statement, parameters)
		end
	end

	def process_class()
		if @current_token.type == TokenType.EOF.type
			return
		end
		@current_token = @lexer.next_token()
		class_name = match(TokenType.IDENTIFIER, " функцын нэр алдаатай ", @lexer.row)
		skip_newline()	# Шинэ мөрийг алгасах функц

		if(@current_token.type == TokenType.LEFTBRACE.type)
			@block = statement()
			return Class_.new(class_name, @block)
		else
			match(TokenType.LEFTBRACE, " мужийн зүүн хаалт дутуу ", @lexer.row)
		end
	end

	def skip_newline()
		while @current_token.type == TokenType.NEWLINE.type
			@current_token = @lexer.next_token()
		end
	end

	def process_static()
		@current_token = @lexer.next_token()

		if is_type() or @current_token.value == TokenType.VOID.value
			@current_token = @lexer.next_token
			@name = match(TokenType.IDENTIFIER, @current_token.value + " алдаатай ", @lexer.row)

			if @current_token.type == TokenType.LEFTPARET.type
				@current_token = @lexer.next_token()
				match(TokenType.RIGHTPARET, @current_token.value + " хаах хаалт дутуу ", @lexer.row)
				skip_newline()
				body = statement()
				return Function.new(@name, body, nil, true)
			end
		else
			match(TokenType.TokenType, " өгөгдлийн төрөл алдаатай ", @lexer.row)
		end
	end



	def statements()
		if @current_token.type == TokenType.EOF.type 
			return 
		end
		block = Block.new
		while @current_token.type != TokenType.RIGHTBRACE.type and @current_token.type != TokenType.EOF.type do
			block.members.push(statement())
		end
		return block
	end

	def statement()
		if @current_token.type == TokenType.EOF.type
			return
		end
		skip = Skip.new
		if @current_token.type == TokenType.NEWLINE.type
			@current_token = @lexer.next_token()
			return skip
		elsif @current_token.value == TokenType.CLASS.value
			return process_class()
		elsif @current_token.value == TokenType.STATIC.value
			return process_static()
		elsif @current_token.value == TokenType.SWITCH.value
			return switch()
		elsif @current_token.type == TokenType.LEFTBRACE.type
			@current_token = @lexer.next_token()
			@stack.push("{")
			block = statements()
			match(TokenType.RIGHTBRACE, " мужийн баруун хаалт дутуу ", @lexer.row)
			@stack.pop
			return block
		elsif is_type()
			decs = process_declaration()
			return Declaration.new("Type", "Declaration", 0, decs)
		elsif @current_token.value == TokenType.PUBLIC.value or @current_token.value == TokenType.PRIVATE.value or @current_token.value == TokenType.PROTECTED.value
			@current_token = @lexer.next_token()
			return function()
		elsif @current_token.type == TokenType.IDENTIFIER.type
			name = match(TokenType.IDENTIFIER, " функцын зүүн дугуй хаалт дутуу ", @lexer.row)
			if @current_token.type == TokenType.LEFTPARET.type
				return call(name)
			else
				return assignment(name)
			end
		elsif @current_token.value == TokenType.WHILE.value
			return while_statement()
		elsif @current_token.value == "do"
			return dowhile_statement()
		elsif @current_token.value == TokenType.IF.value
			return if_statement()
		elsif @current_token.value == TokenType.FOR.value
			return For()
		elsif @current_token.value == TokenType.PRINT.value
			@current_token = @lexer.next_token()

			match(TokenType.DOT, " хэвлэх үйлдлийн бичиглэл буруу ", @lexer.row)
			match(TokenType.WRITELINE, " хэвлэх үйлдлийн бичиглэл буруу ", @lexer.row)
			match(TokenType.LEFTPARET, " Console.WriteLine зүүн дугуй хаалт дутуу ", @lexer.row)
			print_exp = expression()

			if @current_token.type == TokenType.COMMA.type
				print_exp = print_(Print.new(print_exp))
				match(TokenType.RIGHTPARET, " Console.WriteLine баруун дугуй хаалт дутуу ", @lexer.row)
				match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)
				return print_exp
			else
				match(TokenType.RIGHTPARET, " Console.WriteLine баруун дугуй хаалт дутуу ", @lexer.row)
				match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)
				return Print.new(print_exp)
			end
		elsif @current_token.value == TokenType.RETURN.value
			@current_token = @lexer.next_token()
			re_exp = expression()
			match(TokenType.SEMICOLON, " цэгтэй таслал дутуу ", @lexer.row)
			return Return.new(re_exp)
		elsif @current_token.type == TokenType.EOF.type # Файлын төгсгөлд ирсэн
			@current_token = TokenType.EOF
			@parser_error = true
		else
			if @current_token.type == TokenType.EOF.type
				return
			end
			@error_list.push("Мөр: "+ (@lexer.row+1).to_s + " - синтакс алдаа: \n" +@current_token.value+" тэмдэгт буруу")
			@current_token = TokenType.EOF
			@parser_error = true
		end
	end
end

class TokenType
	@@TYPE = Token.new("Type", "")	# энэ юу вэ?
	@@EOF = Token.new("EOF", "~")
	@@HEADER = Token.new("Header", "функц")
	@@NEWLINE = Token.new("Newline", "Шинэ мөр")
	@@OR = Token.new("OR", "||")
	@@AND = Token.new("AND", "&&")
	@@EQUALS = Token.new("Equals", "==")
	@@NOTEQ = Token.new("NotEqual", "!=")
	@@COMPARE = Token.new("Compare", "")
	@@ADD = Token.new("Operator", "+")
	@@SUB = Token.new("Operator", "-")
	@@MUL = Token.new("Operator", "*")
	@@DIV = Token.new("Operator", "/")
	@@PER = Token.new("Operator", "%")
	@@NOT = Token.new("NOT", "!")
	@@MINUS = Token.new("MINUS", "-")
	@@IDENTIFIER = Token.new("Identifier", "")
	@@LEFTPARET = Token.new("Left_Paren", "(")
	@@RIGHTPARET = Token.new("Right_Paren", ")")
	@@SEMICOLON = Token.new("Semicolon", ";")
	@@INT = Token.new("Int", "")
	@@DOUBLE = Token.new("Double", "")
	@@FLOAT = Token.new("Float", "")
	@@CHAR = Token.new("Char", "")
	@@STRING = Token.new("String", "")
	@@BOOL = Token.new("Boolean", "")
	@@COMMA = Token.new("Comma", ",")
	@@ASSIGN = Token.new("Assignment", "=")
	@@INPUT = Token.new("Input", "оруулах")
	@@FOR = Token.new("Keyword", "for")
	@@WHILE = Token.new("Keyword", "while")
	@@DOWHILE = Token.new("Keyword", "while")
	@@IF = Token.new("Keyword", "if")
	@@ELSEIF = Token.new("Keyword", "elseif")
	@@ELSE = Token.new("Keyword", "else")
	@@CLASS = Token.new("Keyword", "class")
	@@RETURN = Token.new("Keyword", "return")
	@@WRITELINE = Token.new("WriteLine", "WriteLine")
	@@BLOCK = Token.new("Block", "")
	@@PRINT = Token.new("Keyword", "Console")
	@@STATIC = Token.new("Keyword", "static")
	@@VOID = Token.new("Keyword", "void")
	@@SWITCH = Token.new("Keyword", "switch")
	@@CASE = Token.new("Keyword", "case")
	@@DEFAULT = Token.new("Keyword", "default")
	@@LEFTBRACE = Token.new("LEFTBRACE", "{")
	@@RIGHTBRACE = Token.new("RIGHTBRACE", "}")
	@@DOT = Token.new("DOT", ".")
	@@COLON = Token.new("Colon", ":")
	@@PUBLIC = Token.new("Keyword", "public")
	@@PRIVATE = Token.new("Keyword", "private")
	@@PROTECTED = Token.new("Keyword", "protected")

	def self.ADD() return @@ADD end
	def self.SUB() return @@SUB end
	def self.MUL() return @@MUL end
	def self.DIV() return @@DIV end
	def self.PER() return @@PER end
	def self.TYPE() return @@TYPE end
	def self.EOF() return @@EOF end
	def self.HEADER() return @@HEADER end
	def self.NEWLINE() return @@NEWLINE end
	def self.OR() return @@OR end
	def self.AND() return @@AND end
	def self.EQUALS() return @@EQUALS end
	def self.NOTEQ() return @@NOTEQ end
	def self.COMPARE() return @@COMPARE end
	def self.NOT() return @@NOT end 
	def self.MINUS() return @@MINUS end
	def self.IDENTIFIER() return @@IDENTIFIER end
	def self.LEFTPARET() return @@LEFTPARET end
	def self.RIGHTPARET() return @@RIGHTPARET end
	def self.SEMICOLON() return @@SEMICOLON end
	def self.INT() return @@INT end
	def self.DOUBLE() return @@DOUBLE end
	def self.CHAR() return @@CHAR end
	def self.STRING() return @@STRING end
	def self.BOOL() return @@BOOL end
	def self.FLOAT() return @@FLOAT end
	def self.COMMA() return @@COMMA end
	def self.ASSIGN() return @@ASSIGN end
	def self.INPUT() return @@INPUT end
	def self.FOR() return @@FOR end
	def self.WHILE() return @@WHILE end
	def self.DOWHILE() return @@DOWHILE end
	def self.IF() return @@IF end
	def self.ELSEIF() return @@ELSEIF end
	def self.ELSE() return @@ELSE end
	def self.RETURN() return @@RETURN end
	def self.BLOCK() return @@BLOCK end
	def self.PRINT() return @@PRINT end
	def self.LEFTBRACE() return @@LEFTBRACE end
	def self.RIGHTBRACE() return @@RIGHTBRACE end
	def self.CLASS() return @@CLASS end
	def self.STATIC() return @@STATIC end
	def self.VOID() return @@VOID end
	def self.DOT() return @@DOT end
	def self.WRITELINE() return @@WRITELINE end
	def self.SWITCH() return @@SWITCH end
	def self.CASE() return @@CASE end
	def self.COLON() return @@COLON end
	def self.DEFAULT() return @@DEFAULT end
	def self.PUBLIC() return @@PUBLIC end
	def self.PRIVATE() return @@PRIVATE end
	def self.PROTECTED() return @@PROTECTED end

end

class Operator
	def initialize(value)
		@value = value
	end
	def value()
		return @value
	end
	def to_s
		return @value.to_s
	end
end

class Expression
	def to_s
		return "expression"
	end
end

class Binary < Expression
	def initialize(op, term, term2)
		@operator = op
		@term = term
		@term2 = term2
	end
	def operator()
		return @operator
	end
	def term()
		return @term
	end
	def term2()
		return @term2
	end
	def to_s
		return "Binary"
	end
end

class Unary < Expression
	def initialize(op, term)
		@operator = op
		@term = term
	end
	def operator()
		return @operator
	end
	def term()
		return @term
	end
	def to_s
		return @operator.to_s+" "+@term.to_s
	end
end

class Variable < Expression
	def initialize(var)
		@id = var
	end
	def to_s
		return @id
	end
end

class Value < Expression
	@type = nil
	@is_defined = false
end

class IntValue < Value
	def initialize(value)
		@value = value
		@type = TokenType.INT.type
		@is_defined = true
	end
	def to_s
		return @value
	end
end

class CharValue < Value
	def initialize(value)
		@value = value
		@type = TokenType.CHAR.type
		@is_defined = true
	end
	def to_s
		return @value
	end
end

class DoubleValue < Value
	def initialize(value)
		@value = value
		@type = TokenType.DOUBLE.type
		@is_defined = true
	end
	def to_s
		return @value
	end
end

class FloatValue < Value
	def initialize(value)
		@value = value
		@type = TokenType.FLOAT.type
		@is_defined = true
	end
	def to_s
		return @value
	end
end

class BoolValue < Value
	def initialize(value)
		@value = value
		@type = TokenType.BOOL.type
		@is_defined = true
	end
	def to_s
		return @value
	end
end

class StringValue < Value
	def initialize(value)
		@value = value
		@type = TokenType.STRING.type
		@is_defined = true
	end
	def to_s
		return @value
	end
end

class Statement
	def to_s
	end
end
class Call < Statement
	def initialize(name, argus)
		@function_name = name
		@arguments = Array.new
		@arguments = argus
	end
	def function_name()
		return @function_name
	end
	def arguments()
		return @arguments
	end
	def to_s
		return @function_name+" "+@arguments.to_s
	end
end
class Print < Statement
	def initialize(first_exp, second_exp = nil)
		@first_exp = first_exp
		@second_exp = second_exp
	end
	def first_exp()
		return @first_exp
	end
	def second_exp()
		return @second_exp
	end
	def to_s
		return "Print"
	end
end
class Assignment < Statement
	def initialize(target, source)
		@target = target
		@source = source
	end
	def target()
		return @target
	end
	def source()
		return @source
	end
	def to_s
		return "Assignment"
	end
end
class Loop < Statement
	def initialize(condition, body, do_while=nil)
		@test = condition
		@body = body
		@is_dowhile = do_while
	end
	def test()
		return @test
	end
	def body()
		return @body
	end
	def is_dowhile()
		return @is_dowhile
	end
	def to_s
		return @test.to_s+" "+@body.to_s
	end
end
class For < Statement
	def initialize(initial, condit, assign, stmnt)
		@initialize = initial
		@condition = condit
		@increment = assign
		@statement = stmnt
	end
	def initializee()
		return @initialize
	end
	def condition()
		return @condition
	end
	def increment()
		return @increment
	end
	def statement()
		return @statement
	end
	def to_s
		return @initialize.to_s+" "+@condition.to_s+" "+@increment.to_s+" "+@statement.to_s
	end
end
class Switch < Statement
	def initialize(expression, condition)
		@s_expression = expression
		@condition = condition
	end

	def switch_exp()
		return @s_expression
	end
	def switch_condition()
		return @condition
	end
	def to_s
		return @condition
	end
end
class Condition < Statement
	def initialize(test, thn, elseif_ = nil, else_ = nil)
		@test = test
		@then_branch = thn
		@elseif_branch = elseif_
		@else_branch = else_
	end
	def test()
		return @test
	end
	def then_branch()
		return @then_branch
	end
	def elseif_branch()
		return @elseif_branch
	end
	def else_branch()
		return @else_branch
	end
	def to_s
		return @test.to_s+" "+@then_branch.to_s+" "+@elseif_branch.to_s+" "+@else_branch.to_s
	end
end
class Block < Statement
	def initialize()
		@members = Array.new
	end
	def members
		return @members
	end
	def to_s
		return @members.to_s
	end
end

class Class_ < Statement
	def initialize(name, block)
		@name = name
		@block = block
	end
	def name
		return @name
	end
	def block
		return @block
	end
	def to_s
		@name.to_s
	end
end

class Function < Statement
	def initialize(name, body, params, is_static=false)
		@function_name = name
		@function_body = body
		@parameters = Array.new
		@parameters = params
		@is_static = is_static
	end
	def function_name
		return @function_name
	end
	def function_body
		return @function_body
	end
	def parameters
		return @parameters
	end
	def is_static
		return @is_static
	end
	def to_s
		return @function_name
	end
end
class Return < Statement
	def initialize(result)
		@result = result
	end
	def result
		return @result
	end
	def to_s
		return "Return"
	end
end

class Skip < Statement
	def to_s
		return "Skip"
	end
end
class Declaration
	attr_accessor :expression

	def initialize(name, type, scope, exp=nil)
		@var_name = name
		@var_type = type
		@scope = scope
		@expression = exp
	end
	def var_name
		return @var_name
	end
	def var_type
		return @var_type
	end
	def scope
		return @scope
	end
	def expression
		return @expression
	end
	def to_s
		return @var_name.to_s+" "+@var_type.to_s+" "+@expression.to_s
	end
end