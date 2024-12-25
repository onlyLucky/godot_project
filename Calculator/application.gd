extends Control

var cal = Calculator.new()
@onready var label_current_number = $PanelContainer/MarginContainer/VBoxContainer/LabelCurrentNumber
@onready var label_result = $PanelContainer/MarginContainer/VBoxContainer/LabelResult

func _ready():
	print("test")
	cal.current_number_changed.connect(_on_current_number_changed)
	cal.result_changed.connect(_on_result_changed)

func _on_result_changed():
	label_result.text = cal.result

func _on_current_number_changed():
	label_current_number.text = cal.current_num

func _on_button_7_pressed():
	cal.input_number(7)

func _on_button_8_pressed():
	cal.input_number(8)


func _on_button_9_pressed():
	cal.input_number(9)


func _on_button_4_pressed():
	cal.input_number(4)


func _on_button_5_pressed():
	cal.input_number(5)


func _on_button_6_pressed():
	cal.input_number(6)


func _on_button_1_pressed():
	cal.input_number(1)


func _on_button_2_pressed():
	cal.input_number(2)


func _on_button_3_pressed():
	cal.input_number(3)


func _on_button_0_pressed():
	cal.input_number(0)


func _on_button_div_pressed():
	pass # Replace with function body.


func _on_button_mul_pressed():
	cal.mul()


func _on_button_add_pressed():
	cal.add()


func _on_button_sub_pressed():
	cal.sub()


func _on_button_equal_pressed():
	cal.equal()
