extends Node

# 用户存档保存位置
const SAVE_PATH :="user://data.sav"

#场景名称 => {
	#enemies_alive => [敌人的路径]
#}
# 场景状态
var world_states :={}

@onready var player_stats: Stats = $PlayerStats
# 切换场景过度动画遮罩
@onready var color_rect: ColorRect = $ColorRect
@onready var default_player_stats := player_stats.to_dict()


func _ready() -> void:
	color_rect.color.a = 0


#场景切换调用函数 entry_point 传送门定位点
func change_scene(path: String, params := {}) -> void:
	var tree := get_tree()
	tree.paused = true #设置场景暂停
	
	# 转场动画
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect,"color:a", 1, 0.2)
	await tween.finished # 等待动画结束
	
	if tree.current_scene is World:
		var old_name := tree.current_scene.scene_file_path.get_file().get_basename()
		world_states[old_name] = tree.current_scene.to_dict()
	
	# 场景树切换场景 旧场景会被移除但不会释放 会在这一帧末尾同意处理（旧的场景还存在，但是不能够访问 下面修改血量会报错 里面的create_tween依赖场景，会报错，）
	# 在 status_planel.gd _ready 中 解除 health_changed energy_changed 改变 connect tree_exited.connect
	tree.change_scene_to_file(path)

	# init 匿名函數调用 在切换场景文件之后进行血量切换
	if "init" in params:
		params.init.call()
	
	#await tree.process_frame # 4.2 以前 等待一帧
	await tree.tree_changed # 4.2 等待节点改变信号后

	if tree.current_scene is World:
		var new_name := tree.current_scene.scene_file_path.get_file().get_basename()
		if new_name in world_states:
			tree.current_scene.from_dict(world_states[new_name])
		
		# 传送位置过来
		if "entry_point" in params:
			for node in tree.get_nodes_in_group("entry_points"):
				if node.name == params.entry_point:
					tree.current_scene.update_player(node.global_position, node.direction)
					break
		
		# 加载游戏存档文件
		if "position" in params and "direction" in params:
			tree.current_scene.update_player(params.position, params.direction)

	tree.paused = false #解除暂停
	
	# 遮罩过渡消失
	tween = create_tween()
	tween.tween_property(color_rect,"color:a", 0, 0.2)

# 保存游戏
func save_game() -> void:
	var scene := get_tree().current_scene
	var scene_name := scene.scene_file_path.get_file().get_basename()
	world_states[scene_name] = scene.to_dict()
	
	var data := {
		world_states = world_states, # 野怪生死
		stats=player_stats.to_dict(),#血量
		scene=scene.scene_file_path,#场景
		player={#玩家位置，朝向
			direction=scene.player.direction,
			position={
				x=scene.player.global_position.x,
				y=scene.player.global_position.y
			}
		}
	}
	var json := JSON.stringify(data)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		return
	file.store_string(json)


# 加载游戏
func load_game() -> void:
	var file := FileAccess.open(SAVE_PATH,FileAccess.READ)
	if not file:
		return
	
	var json := file.get_as_text()
	var data := JSON.parse_string(json) as Dictionary

	change_scene(data.scene, {
		direction=data.player.direction,
		position=Vector2(data.player.position.x,data.player.position.y),
		init=func():
			world_states = data.world_states
			player_stats.from_dict(data.stats)
	})

# 新游戏
func new_game() -> void:
	change_scene("res://worlds/forest.tscn", {
		init=func():
			world_states = {}
			player_stats.from_dict(default_player_stats)
	})

func back_to_title() -> void:
	change_scene("res://ui/title_screen.tscn")
	
func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
