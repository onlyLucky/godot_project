extends "res://scenes/Scene.gd"

@onready var board = $Board
@onready var gear = $Reset/Gear


# 重置点击（先转动360 在点击执行重置）
func _on_reset_interact():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	# as_relative() 设置转动相对值 不论默认值为多少，都会转动360
	tween.tween_property(gear, "rotation_degrees", 360.0, 0.2).as_relative() 
	tween.tween_callback(board.reset)
