extends Control

var cal = Calculator.new()
@onready var label_current_number = $PanelContainer/MarginContainer/VBoxContainer/LabelCurrentNumber
@onready var label_result = $PanelContainer/MarginContainer/VBoxContainer/LabelResult

@onready var button_percent = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/ButtonPercent
@onready var button_symbol = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/ButtonSymbol
@onready var button_point = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/ButtonPoint
@onready var button_div = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ButtonDiv
@onready var button_mul = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ButtonMul
@onready var button_sub = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ButtonSub
@onready var button_equal = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ButtonEqual
@onready var button_add = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ButtonAdd


func _ready():
	print("test")
	cal.current_number_changed.connect(_on_current_number_changed)
	cal.result_changed.connect(_on_result_changed)
	cal.is_error_num.connect(_on_is_error_num)

func _on_is_error_num():
	button_percent.disabled = cal.is_error
	button_symbol.disabled = cal.is_error
	button_point.disabled = cal.is_error
	button_div.disabled = cal.is_error
	button_mul.disabled = cal.is_error
	button_sub.disabled = cal.is_error
	button_equal.disabled = cal.is_error
	button_add.disabled = cal.is_error

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
	cal.div()


func _on_button_mul_pressed():
	cal.mul()


func _on_button_add_pressed():
	cal.add()


func _on_button_sub_pressed():
	cal.sub()


func _on_button_equal_pressed():
	cal.equal()


func _on_button_clear_pressed():
	cal.clear()


func _on_button_clear_single_pressed():
	cal.clearSingle()


func _on_button_symbol_pressed():
	cal.changeSymbol()
