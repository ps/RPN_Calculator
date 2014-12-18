# Author: Pawel Szczurko
# 
# Unit tests module for RPN calculator

require "test/unit"
require_relative "rpn_core"

class TestRPN < Test::Unit::TestCase
	def test_all_get_float()
		num = 0
		while num < 10
			num_str = "%s" % num
			assert_equal(num, get_float(num_str))
			num += 1
		end
	end

	def test_bad_input_get_float()
		input = ["pawel", "48", "", 0]
		while input.length > 0
			assert_raise RuntimeError do
				get_float(input.pop)
			end
		end
	end

	def test_positive_atof()
		input = ["1", "1.1", "28", "28.95746"]
		output = [1, 1.1, 28, 28.95746]
		while input.length > 0
			assert_equal(output.pop, atof(input.pop))
		end
	end

	def test_negative_atof()
		input = ["-1", "-1.1", "-28", "-28.95746"]
		output = [-1, -1.1, -28, -28.95746]
		while input.length > 0
			assert_equal(output.pop, atof(input.pop))
		end
	end

	def test_bad_input_atof()
		input = ["", "pawel", "4a", "-48.4d9", 0]
		while input.length > 0
			assert_raise RuntimeError do
				atof(input.pop)
			end
		end
	end

	def test_is_sign()
		input = ["-", "+", "*", "/", "--", "a", 0]
		output = [true, true, true, true, false, false, false]
		while input.length > 0
			assert_equal(output.pop, is_sign(input.pop))
		end
	end

	def test_expand_digit()
		input = [-1, 1, -2, 2, 4, 3, -6, -5]
		output = ["-1", "1", "-2", "2", "2 2 +", "2 1 +", "-2 -2 -2 + +", "-2 -2 -1 + +"]
		while input.length > 0
			assert_equal(output.pop, expand_digit(input.pop))
		end
	end

	def test_expand_expr()
		input = ["4 2 +", "-4 2 +", "2 1 +", "4 2 *"]
		output = ["2 2 + 2 +", "-2 -2 + 2 +", "2 1 +", "2 2 + 2 *"]
		while input.length > 0
			assert_equal(output.pop, expand_expr(input.pop))
		end
		assert_raise RuntimeError do
			expand_expr("pawel")
		end
	end

	def test_perform_op()
		input = [["-", 4, 5], ["-", 5, 4], ["+", 5.0, 4.0], ["*", 5, 4], ["/", 2, 4]]
		output = [1, -1, 9, 20, 2]
		while input.length > 0
			test_data = input.pop
			sign = test_data[0]
			num1 = test_data[1]
			num2 = test_data[2]
			assert_equal(output.pop, perform_op(sign, num1, num2))
		end
	end

	def test_bad_input_perform_op()
		input = [[5, 5, 4], ["+asdf", 5, 4], ["*", "", 4], ["/", 2, "-"]]
		while input.length > 0
			assert_raise RuntimeError do
				test_data = input.pop
				sign = test_data[0]
				num1 = test_data[1]
				num2 = test_data[2]
				perform_op(sign, num1, num2)
			end
		end
	end

	def test_calc_rpn_basic()
		input = ["1 2 +", "-1 2 +", "-1.2 2 +", 
				"2 4 -", "4 2 -", "2 -4 -", "-2.1 4 -",
				"4 2 /", "-2 4 /", "-2.1 4 /",
				"4 2 *", "-2 4 *", "-2.1 4 *"]
		output = [3, 1, 0.8,
				  -2, 2, 6, -6.1,
				  2, -0.5, -0.525,
				  8, -8, -8.4]
		while input.length > 0
			assert_equal(output.pop, calc_rpn(input.pop))
		end
	end

	def test_calc_rpn_intermediate()
		input = ["2 3 4 + *", "3 4 + 5 6 + *", "13 4 -"]
		output = [14, 77, 9]
		while input.length > 0
			assert_equal(output.pop, calc_rpn(input.pop))
		end
	end

	def test_bad_input_calc_rpn()
		few_args = "1 +"
		assert_equal("Not enough arguments!", calc_rpn(few_args))
		few_args = "a b +"
		assert_equal("Invalid number!", calc_rpn(few_args))
	end

end