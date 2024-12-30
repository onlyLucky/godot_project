class_name Calculator
extends RefCounted

signal current_number_changed
signal result_changed
signal is_error_num # NaN

# 算数是否报错
var is_error: bool = false:
	set(v):
		is_error = v
		is_error_num.emit()

#最顶上显示label text
var result: String = "":
	set(v):
		result = v
		result_changed.emit()

# 是否为第一次输入
var new_number: bool = true
# 第二行显示label text
var current_num: String = "0": 
	set(v):
		current_num = v
		current_number_changed.emit()
	
var num1: String = ""
var sign: String = ""
var num2: String = ""
# 当前是否为等于
var isEqual: bool = false

func _init():
	current_num = "0"
	print("init")

func input_number(value: Variant):
	if is_error or isEqual:
		clear()
	if new_number:
		current_num = ""
		new_number = false
	if current_num.length()<=0 or current_num=='0':
		current_num = ""
	
	if value is String and value == ".":
		if current_num.length()<=0:
			current_num = "0"
	
	current_num += str(value)
	if sign:
		num2 = current_num

func clear():
	current_num = "0"
	num1 = ""
	sign = ""
	num2 = ""
	isEqual = false
	is_error = false
	get_result()
	new_number = true

func clearSingle():
	if isEqual:
		result = ""
		return
	if current_num == '0':
		return
	current_num = "0" if current_num.length()<=1 else current_num.substr(0, current_num.length() - 1)
	
	if sign:
		num2 = current_num
	

func changeSymbol():
	if current_num == '0':
		return
	if current_num.contains("-"):
		current_num = current_num.replace("-",'')
	else:
		current_num = "-" + current_num
	if sign:
		num2 = current_num
	else:
		num1 = current_num

func calculate_function(_sign: String):
	new_number = true
	isEqual = false
	if not num1 :
		num1 = current_num
	
	if sign and num2:
		var res_num = calculate()
		current_num = res_num
		num1 = res_num
		num2 = ""
		new_number = true
		
	sign = _sign
	get_result()

func add():
	calculate_function("+")

func sub():
	calculate_function("-")

func mul():
	calculate_function("*")
	
func div():
	calculate_function("/")

func equal():
	if not current_num or not sign:
		return
	if not num1:
		num1 = current_num
		return
	if not num2:
		num2 = current_num
	isEqual = true
	var res_num = calculate()
	current_num = res_num
	new_number = true
	get_result()
	num1 = current_num

func get_result():
	result = num1 + " " + sign + " "
	if isEqual:
		result += num2 + " = "
	

func calculate():
	var res_num
	var oneValue = float(num1)
	var twoValue = float(current_num)
	if num2:
		twoValue = float(num2)
	if sign == "+":
		res_num = oneValue+twoValue
	if sign == "-":
		res_num = oneValue-twoValue
	if sign == "*":
		res_num = oneValue*twoValue
	if sign == "/":
		if twoValue == 0:
			res_num = '除数不能为0'
			is_error = true
		else:
			res_num = oneValue/twoValue
		
	return str(res_num)
