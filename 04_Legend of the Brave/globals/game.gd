extends Node

@onready var player_stats: Stats = $PlayerStats

#场景切换调用函数
func change_sceen(path: String, entry_point: String) -> void:
	var tree := get_tree()
	
	# 场景树切换场景
	tree.change_scene_to_file(path)
	# 等待一帧
	#await tree.process_frame
	# 4.2 等待节点改变信号后
	await tree.tree_changed
	print("tree.tree_changed")
	
	for node in tree.get_nodes_in_group("entry_points"):
		print("entry_points",entry_point)
		if node.name == entry_point:
			print(node.global_position,"node.global_position")
			tree.current_scene.update_player(node.global_position, node.direction)
			break
	
	
