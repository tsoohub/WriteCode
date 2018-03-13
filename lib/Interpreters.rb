class Interpreters
	
	require "lexer"
	require "parser"
	attr_accessor :parser
	
	def initialize(file_path)
		@lexer = Lexer.new
		@lexer.set_file_to_array(file_path)
		@parser = Parser.new(@lexer)

		@i = 0
		@scope = 0
		@debug = false
		@_return = nil
		@print_result = Array.new
		@conditions = Array.new # Нөхцөл шалгах үйлдлийн нөхцөлийг хадгална

		@for_initial = nil
		@for_finish = nil
		@for_step = 0
	end

	def lexer
		return @lexer
	end
	def parser
		return @parser
	end
	def print()
		return @print_result
	end
	def error()
		return @parser.error_list()
	end
	def conditions()
		return @conditions
	end
	def for_initial
		return @for_initial
	end
	def for_finish
		return @for_finish
	end
	def for_step
		return @for_step
	end

	def program_runner()
		@mmbrs = @parser.statements()
		return statement(@mmbrs.members)
	end
	def statements()
		return @mmbrs
	end

	def statement(members)
		for member in members do

			if member.is_a? Assignment

				if not is_declared(member.target.to_s) # Хувьсагч зарлагдсан эсэсхийг шалгаж байна
					@parser.error_list.push(member.target.to_s + " нэртэй хувьсагч зарлагдаагүй ")
					@parser.parser_error = true
					return
				end

				target = member.target
				source = member.source

				if source.is_a? Token
					puts "Гараас утга оруулна уу: "
					text = gets
					source = text
				else
					source = expression(source)
				end
				source = convert(target, source)
				#debug here
				set_new_source_to_old_source(target, source)

			elsif member.is_a? Skip
				#debug here
				next
			elsif member.is_a? Loop
				@scope += 1
				test = member.test
				body = member.body
				if member.is_dowhile
					while true do
						statement(body.members)
						remove_scope_variable(@scope)
						if expression(test).to_s != "true"
							break
						end
					end
				else
					while expression(test).to_s == "true" do
						statement(body.members)
						remove_scope_variable(@scope)
					end
				end
				remove_scope_variable(@scope)
				@scope -= 1
			
			elsif member.is_a? Class_
				@scope += 1
				if member.name == "Program"
					statement(member.block.members)
				end
				@scope -= 1
			elsif member.is_a? Function
				@scope += 1
				if member.function_name == "Main" and member.is_static == true
					statement(member.function_body.members)
				end
				@scope -= 1
			elsif member.is_a? Declaration
				locals = member.expression
				for local in locals do
					if is_declared(local.var_name)
						@parser.error_list.push(local.var_name + " зарлагдсан хувьсагч байна.")
						@parser.parser_error = true
					else
						# debug here

						@parser.declarations.push(local)
					end
				end
			elsif member.is_a? Print
				first = member.first_exp()
				second = member.second_exp()
				result = Array.new

				if second.is_a? Print
					while second.is_a? Print do
						result.push(expression(second.first_exp()).to_s+" ")
						second = second.second_exp()
					end
					result = result.reverse!
					for res in result do
						@print_result.push(res)
					end
				end
				if second == nil
					@print_result.push(expression(first).to_s+" ")
					@print_result.push("\n")
				else
					@parser.error_list.push("Print cинтакс алдаа")
					@parser.parser_error = true
				end
			elsif member.is_a? Condition
				@scope += 1
				test = member.test
				then_ = member.then_branch

				test = expression(test)
				@conditions.push(test)

				if test == "true"
					statement(then_.members)
					if @_return != nil
						return @_return
					end
				elsif member.elseif_branch != nil
					condition(member.elseif_branch)
					if @_return != nil
						return @_return
					end
				elsif member.else_branch != nil
					statement(member.else_branch.members)
					if @_return != nil
						return @_return
					end
				end
				remove_scope_variable(@scope)
				@scope -= 1

			elsif member.is_a? Switch
				@scope += 1
				test = expression(member.switch_exp)	# Switch - ийн илэрхийлэл
				test1 = expression(member.switch_condition.test)	# Эхний case-ийн илэрхийлэл
				@conditions.push(test1) # Switch эхний case-ийг нэмнэ. Switch-ийг шалгахдаа case - бүрийн утга зөв эсэхийг шалгана

				if test == test1
					statement(member.switch_condition.then_branch.members)
				elsif member.switch_condition.elseif_branch != nil
					condition(member.switch_condition.elseif_branch, test)
					if @_return != nil
						return @_return
					end
				elsif member.switch_condition.else_branch != nil
					statement(member.switch_condition.else_branch.members)
					if @_return != nil
						return @_return
					end
				end
				remove_scope_variable(@scope)
				@scope -= 1

			elsif member.is_a? Call
				call(member)
				next
			elsif member.is_a? Return
				@_return = expression(member.result)
				return @_return
			elsif member.is_a? For
				@scope += 1
				initial = member.initializee
				condition = member.condition
				increment = member.increment
				body = member.statement
				target = nil
				old_source = nil

				if initial.is_a? Assignment

					if not is_declared(initial.target.to_s) # Хувьсагч зарлагдсан эсэсхийг шалгаж байна
						@parser.error_list.push(initial.target.to_s + " нэртэй хувьсагч зарлагдаагүй ")
						@parser.parser_error = true
						return
					end
					target = initial.target
					source = expression(initial.source)
					source = convert(target, source)

					@for_initial = source # For - ын анхны утга
					# debug here
					set_new_source_to_old_source(target, source)
				elsif initial.is_a? Declaration
					target = initial.var_name
					old_source = initial.expression

					@for_initial = expression(old_source) # For - ын анхны утга lesson_controller ашиглана
					# debug here
					@parser.declarations.push(initial)
				end

				while expression(condition).to_s == "true" do
					statement(body.members)
					sorc = expression(increment.source)

					set_new_source_to_old_source(increment.target, sorc)
					remove_scope_variable(@scope)

					@for_step += 1 # For - ын хэдэн удаа давтасан утга
				end

				@for_finish = sorc # For-ын дууссан утга

				set_new_source_to_old_source(target, old_source)
				remove_scope_variable(@scope)
				@scope -= 1
				
			end
		end
		return @print_result
	end

	def expression(exp)
		if @parser.parser_error
			return
		end
		if exp.is_a? Binary
			operator = exp.operator
			term = expression(exp.term)
			term2 = expression(exp.term2)
			return Preprocessor.check_operator(operator, term.to_s, term2.to_s)
		elsif exp.is_a? Unary
			operator = exp.operator
			term = expression(exp.term)
			return Preprocessor.check_operator(operator, term.to_s)
		elsif exp.is_a? Value
			return exp.to_s
		elsif exp.is_a? Variable
			var_exp = nil
			exists = false
			
			for declar in @parser.declarations do
				if declar.var_name == exp.to_s
					target = declar.var_name
					exists = true
					var_exp = declar.expression

					if var_exp.is_a? Expression
						var_exp = expression(var_exp)
						var_exp = convert(declar.var_name, var_exp) # Хувьсагчийг нэрээр нь хайж олоод expression-ийн тухайн хувьсагчийн төрөлрүү хөрвүүлнэ

						if @debug
							@i += 10
						end
					elsif var_exp.is_a? Call
						var_exp = call(var_exp)
					end
				end
			end
			if not exists
				@parser.error_list.push(exp.to_s + " нэртэй хувьсагч зарлагдаагүй ")
				@parser.parser_error = true
				return
			else
				return var_exp
			end
		elsif exp.is_a? Call
			return call(exp)
		else 
			return "Kiss your own ass"
		end
		return exp
	end

	def call(function)
		call_name = function.function_name
		call_args = function.arguments
		@is_fun = false
		body = nil

		@parser.functions.each do |fun|

			if fun.function_name == call_name
				@is_fun = true
				body = fun.function_body
				if call_args.length != fun.parameters.length
					@parser.error_list.push(call_name+" функцийн параметр дутуу ")
					@parser.parser_error = true
					return
				end
				fun.parameters.each_with_index do |element,index|
					fun.parameters[i].expression = expression(call_args[i])
					@parser.declarations.push(fun.parameters[i])
				end
			end
		end

		if not @is_fun
			@parser.error_list.push(call_name+" нэртэй функц зарлагдаагүй ")
			@parser.parser_error = true
			return
		end

		return_value = statement(body.members)
		#del self.parser.declarations[ (len(self.parser.declarations)-len(call_args)) : len(self.parser.declarations) ] # Функц дотор зарлагдсан хувьсагчдыг устгана
		return return_value
	end
	def condition(else_if, switch_test = nil)
		if @parser.parser_error
			return
		end
		test = expression(else_if.test)
		then_ = else_if.then_branch()
		@conditions.push(test)

		# Switch нөхцөл
		if switch_test != nil
			if test == switch_test
				statement(then_.members)
			elsif else_if.elseif_branch != nil
				condition(else_if.elseif_branch, switch_test)
			elsif else_if.else_branch != nil
				statement(else_if.else_branch.members)
			end

		# If нөхцөл
		elsif test == "true"
			statement(then_.members)
			if @_return != nil
				return @_return
			end
		elsif else_if.elseif_branch != nil
			condition(else_if.elseif_branch)
		elsif else_if.else_branch != nil
			
			statement(else_if.else_branch.members)
		end
	end
	def remove_scope_variable(scope)
		delete_index = Array.new
		@parser.declarations.each_with_index do |element,index| # Тухайн scope буюу хүрээн доторх элементүүдийн индескийг авч байна
			if @parser.declarations[index].scope == scope
				delete_index.push(index)
			end
		end
		for i in delete_index do # Тухайн индекст харгалзах declaration-ы элементийг устгана
			@parser.declarations.delete_at(i)
		end
	end
	def set_new_source_to_old_source(target, source)


		@parser.declarations.each_with_index do |element,index|
			if @parser.declarations[index].var_name == target.to_s
				@parser.declarations[index].expression = source
			end
		end
	end
	def is_declared(var_name)
		@debug = false
		for declar in @parser.declarations
			if declar.var_name == var_name
				@debug = true
			end
		end
		return @debug
	end
	def convert(target, source)
		case get_type(target.to_s)
			when "Int"
				source = source.to_i
			when "Double"
				source = source.to_f
			when "Float"
				source = source.to_f
			when "String"
				source = source.to_s
			when "Char"
				source = source.to_s
			when nil
				@parser.parser_error = true
				source = target.to_s+" doesn't found variable."
		end
		return source
	end
	def get_type(var_name)
		for declar in @parser.declarations
			if declar.var_name == var_name
				return declar.var_type
			end
		end
		return nil
	end
end


class Preprocessor
	def initialize()
	end
	def self.check_operator(operation, term, term2=nil)
		if term2 == nil
			return unaryop(operation.value, term)
		end
		case operation.value
			when "+", "-", "*", "/", "%","++", "--", "+=", "-="
				return arithmetic(operation.value, term, term2)
			when "||", "&&", "==", "!="
				return logical(operation.value, term, term2)
			when ">", "<", ">=", "<="
				return compare(operation.value, term, term2)
			when "."
				return term.to_s + term2.to_s
		end
	end
	def self.arithmetic(operation, term, term2)
		term = converter(term)
		term2 = converter(term2)
		case operation
			when "+", "++", "+="
				return term + term2
			when "-", "--", "-="
				return term - term2
			when "*"
				return term * term2
			when "/"
				return term / term2
			when "%"
				return term % term2
		end
	end
	def self.logical(operation, term, term2)
		if isnumber(term)
			term = converter(term)
		end
		if isnumber(term2)
			term2 = converter(term2)
		end
		if operation == "||"
			if term == "true" or term2 = "true"
				return "true"
			else
				return худал
			end
		elsif operation == "&&"
			if term == "true" and term2 == "true"
				return "true"
			else
				return "false"
			end
		elsif operation == "=="
			if term == term2
				return "true"
			else
				return "false"
			end
		elsif operation == "!="
			if term != term2
				return "true"
			else
				return "false"
			end
		end
	end
	def self.compare(operation, term, term2)
		if isnumber(term)
			term = converter(term)
		end
		if isnumber(term2)
			term2 = converter(term2)
		end
		if operation == ">"
			if term > term2
				return "true"
			else
				return "false"
			end
		elsif operation == ">="
			if term >= term2
				return "true"
			else
				return "false"
			end
		elsif operation == "<"
			if term < term2 
				return "true"
			else
				return "false"
			end
		elsif operation == "<="
			if term <= term2 
				return "true"
			else
				return "flase"
			end
		end
	end
	def self.unaryop(operation, term)
		if isnumber(term)
			term = converter(term)
		end
		if operation.value == '!'
			if term == "false"
				return "true"
			elsif term == "true"
				return "false"
			end
		elsif operation.value == "-"
			if term < 0
				return term.abs
			else
				return term * -1
			end
		end
	end
	def self.isnumber(s)
	  Integer(s)
	  return true
	rescue ArgumentError, TypeError
	  return false
	end
	def self.converter(term)
		if term.include? "."
			return term.to_f
		else
			return term.to_i
		end
	end
end