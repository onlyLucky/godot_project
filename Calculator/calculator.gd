class_name Calculator
extends RefCounted

signal current_number_changed
signal result_changed

var result: String = ""

var new_number: bool = true
var current_num: String = "0"
var num1: String = ""
var sign: String = ""
var num2: String = ""

func _init():
	print("init")

func input_number(value: int):
	if new_number:
		current_num=""
		new_number=false
	current_num+=str(value)
	current_number_changed.emit()

func calculate_function(_sign: String):
	new_number = true
	if not num1:
		num1 = current_num
		sign = _sign
		get_result()
		result_changed.emit()
		return
	if num2:
		num2 = ""
	var res_num = calculate()
	num1 = res_num
	current_num = res_num
	get_result()
	result_changed.emit()

func add():
	calculate_function("+")

func sub():
	calculate_function("-")

func mul():
	calculate_function("*")

func equal():
	if not current_num:
		return
	if not num1:
		num1 = current_num
		return
	if not num2:
		num2 = current_num
	var res_num = calculate()
	current_num = res_num
	new_number = true
	get_result()

func get_result():
	result=num1+sign
	if num2:
		result+=num2+"="
	

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
	return str(res_num)
