# Author: Pawel Szczurko
# 
# Written on Ruby 1.9.3p0
# 
# Description: Basic Reverse Polish Notation calculator
# 
# Basic Usage
# ===========
# 	ruby rpn.rb "1 2 +"
# 	
# 	Expand Expression:
# 	ruby rpn.rb "1 4 +" -e 
# 	
# 	Display Help:
# 	ruby rpn.rb "1 2 +" -h
# 	ruby rpn.rb -h
# 	
# 	Run Unit Tests:
# 	ruby rpn.rb "1 2 +" -t
# 	ruby rpn.rb -t
# 	
# Note
# ========
# This was my first time writting Ruby code ever. Please excuse
# any cringe worthy style errors that I potentially made.

require_relative "rpn_core"

correct_format = "Correct format: ruby rpn.rb <rpn> <flag>\nFlags: -h => help -e => expand" 
error_msg = "Incorrect arguments passed!\n\n%s" % correct_format

first_arg = ARGV[0]
second_arg = ARGV[1]

if first_arg == "" or first_arg == nil
	puts error_msg
	exit
elsif first_arg == "-t" or second_arg == "-t"
	exec 'ruby test_rpn.rb'
	exit
elsif first_arg == "-h" or second_arg == "-h"
	puts correct_format
	exit
end

if second_arg == "-e"
	puts "Expression: %s" % first_arg
	output = calc_rpn(first_arg)
	if output.is_a?(String)
		puts "Result: %s" % output
		exit
	end
	puts "Result: %s" % output
	exp_out = expand_expr(first_arg)
	puts "Expanded expression: %s" % exp_out
	puts "Result: %s" % calc_rpn(exp_out)
else
	puts "Expression: %s" % first_arg
	puts "Result: %s" % calc_rpn(first_arg)
end
