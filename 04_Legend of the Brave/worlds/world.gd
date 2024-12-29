class_name World
extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var player: Player = $Player

func _ready() -> void:
	# 设置 相机 limit
	# grow(-1) 缩小一格
	var used := tile_map.get_used_rect().grow(-1)
	var tile_size := tile_map.tile_set.tile_size
	
	camera_2d.limit_top = used.position.y * tile_size.y
	camera_2d.limit_right = used.end.x * tile_size.x
	camera_2d.limit_bottom = used.end.y * tile_size.y
	camera_2d.limit_left = used.position.x * tile_size.x
	# 清除刚开始的镜头过度
	camera_2d.reset_smoothing()
	
# 测试输入
func _unhandled_input(event: InputEvent) -> void:
	# 按下esc
	if event.is_action_pressed("ui_cancel"):
		Game.back_to_title()

# 更新 用户位置，朝向信息
func update_player(pos: Vector2, direction: Player.Direction) -> void:
	print("update_player",pos,direction)
	player.global_position = pos
	player.direction = direction
	# 取消相机移动过渡
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()
	

# 储存场景状态数据
func to_dict() -> Dictionary:
	var enemies_alive = []
	for node in get_tree().get_nodes_in_group('enemies'):
		var path := get_path_to(node)
		enemies_alive.append(path)
	
	return {
		enemies_alive = enemies_alive
	}


func from_dict(dict: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group('enemies'):
		var path := get_path_to(node)
		if String(path) not in dict.enemies_alive:
			node.queue_free()
