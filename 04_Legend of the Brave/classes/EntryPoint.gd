class_name EntryPoint

# 设置入口位置
extends Marker2D

@export var direction := Player.Direction.RIGHT

func _ready() -> void:
	# 添加到entry_points 组里面
	add_to_group("entry_points")
