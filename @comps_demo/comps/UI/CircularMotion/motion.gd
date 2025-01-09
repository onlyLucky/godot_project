extends Control

var angle_offset = 0
var radius = 150

"""
"""

@onready var texture_rect: TextureRect = $Control/TextureRect

func _physics_process(delta: float) -> void:
	angle_offset += PI * delta
	angle_offset = wrapf(angle_offset, -PI, PI)
	# 计算平台的下一个位置
	var new_position = Vector2()
	new_position.x = cos(angle_offset)*radius
	new_position.y = sin(angle_offset)*radius
	texture_rect.position = new_position
