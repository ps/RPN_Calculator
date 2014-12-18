# Author: Pawel Szczurko
# 
# The core of the RPN functionality.

# Internal: Converts string to integer
# 
# digit - string representation of 0-9
#
# Returns an integer representation of the passed string
# 
# Raises RuntimeError if:
# 	-either 0-9 is not passed
# 	-the passed string has length greater than 1
# 	-incorrect type is passed
def get_float(digit)
	raise "Incorrect type." if !digit.is_a?(String)
	l = digit.length
	raise "Incorrect digit format passed." if l > 1 or l == 0
	# ascii value of '0' is 48
	d = digit.ord - 48
	raise "Value passed is not a digit." if !(d >= 0 and d <= 9)
	return d
end

# Internal: Converts passed string into its corresponding float
# 	representation.
# 
# str - string representation of a floating point number
# 
# Returns a float represented by the passed string
# 
# Raises RuntimeError if:
# 	-empty string passed
# 	-if an invalid string is passed, an error will be thrown by 'get_float'
# 	-if wrong type is passed 	
def atof(str)
	raise "Incorrect type." if !str.is_a?(String)
	raise "Empty string passed. " if str.length == 0
	num = 0.0
	dec_count = 0
	neg = false
	if str[0] == "-"
		neg = true
		str = str[1..-1]
	end

	seen_decimal = false
	str.split("").each do |i|
		if i=="."
			seen_decimal=true
			next
		end
		dec_count +=1 if seen_decimal
		num = num * 10 + get_float(i)
	end

	# convert to appropriate decimal representation
	# if necessary
	num = dec_count!=0 ? num / (10**dec_count) : num

	# make number negative
	num = neg ? num*-1 : num
	return num
end

# Internal: Indicates whether a passed string is a mathematical
# 	operation sign.
# 	
# str - string representation of a mathematical sign
# 
# Returns true if it is a sign, false otherwise
def is_sign(str)
	return true if (str == "+" or str == "-" or 
		str == "*" or str == "/")
	return false
end

# Internal: Expands a digit into a sequence of 2's and '1'
# 
# d - Float or Integer type to be expanded
# 
# Returns the correct string expansion of the provided digit
# 
# Raises RuntimeError if an incorrect type is passed
def expand_digit(d)
	raise "Incorrect type." if !d.is_a?(Float) and !d.is_a?(Integer)
	# an 'int' was not passed
	return d if d % 2 != 0 and (d-1) % 2 != 0

	two = "2"
	one = "1"
	# two or one don't need to be expanded
	return (d < 0 ? "-%s" % one : one) if d.abs == 1
	return (d < 0 ? "-%s" % two : two) if d.abs == 2
	# take care of negative numbers
	if d < 0
		two="-2"
		one="-1"
		d*=-1
	end

	str = two
	# for odd numbers
	if d % 2 != 0
		str = "%s %s +" % [two,one]
		d-=1
	end
	n = d/2
	
	# expansion happes here
	while n > 1 do
		str = "%s %s +" % [two, str]
		n-=1
	end
	return str
end

# Public: Expands a given expression into an expression composed
# 	of 1s and 2s only.
# 
# str - string expression to be expanded
# 
# Returns expanded string expression
# 
# Raises RuntimeError if an incorrect type is passed
def expand_expr(str)
	raise "Incorrect type." if !str.is_a?(String)
	new_str = ""
	str.split(" ").each do |i|
		if !is_sign(i)
			new_str += "%s " % expand_digit(atof(i))
		else
			new_str += "%s " % i
		end
	end
	new_str = new_str[0..-2]

	return new_str
end

# Internal: Performs the specified operation on two digits
# 
# op - string representation of operation to be performed
# num1 - float or integer
# num2 - float or integer
# 
# Returns the result of the requested operation
# 
# Raises RuntimeError if:
# 	-incorrect type is passed
# 	-incorrect sign is passed
def perform_op(op, num1, num2)
	raise "Incorrect number type." if ( (!num1.is_a?(Float) and !num1.is_a?(Integer)) or
		(!num2.is_a?(Float) and !num2.is_a?(Integer)))
	if op=="+"
		return num1+num2
	elsif op=="-"
		return num2-num1
	elsif op=="*"
		return num1*num2
	elsif op=="/"
		return num2/num1
	end
	raise "Incorrect opperation."
end

# Public: Perfomrs the RPN calculation 
# 
# str - string representation of an rpn expression
# 
# Returns the correct calculation or error message
def calc_rpn(str)
	# stack for numbers
	nums = Array.new
	str.split(" ").each do |i|
		if is_sign(i)
			num1 = nums.pop
			num2 = nums.pop
			if num1==nil or num2==nil
				return "Not enough arguments!"
			end
			res = perform_op(i,num1,num2)
			nums.push(res)
		else 
			digit = 0
			begin
				digit = atof(i)
			rescue
				return "Invalid number!"
			end
			nums.push(digit)
		end
		
	end

	if nums.length > 1
		return "Wrong input format!"
	end
	return nums.pop
end
