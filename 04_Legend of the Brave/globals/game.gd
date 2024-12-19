extends Node


#场景名称 => {
	#enemies_alive => [敌人的路径]
#}
# 场景状态
var world_states :={}

@onready var player_stats: Stats = $PlayerStats
# 切换场景过度动画遮罩
@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	color_rect.color.a = 0


#场景切换调用函数
func change_sceen(path: String, entry_point: String) -> void:
	var tree := get_tree()
	tree.paused = true #设置场景暂停
	
	# 转场动画
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect,"color:a", 1, 0.2)
	await tween.finished # 等待动画结束
	
	var old_name := tree.current_scene.scene_file_path.get_file().get_basename()
	world_states[old_name] = tree.current_scene.to_dict()
	
	# 场景树切换场景
	tree.change_scene_to_file(path)
	
	#await tree.process_frame # 4.2 以前 等待一帧
	await tree.tree_changed # 4.2 等待节点改变信号后

	var new_name := tree.current_scene.scene_file_path.get_file().get_basename()
	if new_name in world_states:
		tree.current_scene.from_dict(world_states[new_name])
	
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position, node.direction)
			break
	
	tree.paused = false #解除暂停
	
	# 遮罩过渡消失
	tween = create_tween()
	tween.tween_property(color_rect,"color:a", 0, 0.2)
	
