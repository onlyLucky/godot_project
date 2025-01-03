class_name Teleporter

# 场景切换， 传送器类
extends Interactable

#导入切换场景文件
@export_file("*.tscn") var path: String
# 传送入口点
@export var entry_point: String

func interact() -> void:
	super()
	# 只有在空闲帧中才会执行
	#get_tree().change_scene_to_file(path)
	#await get_tree().process_frame # 等一帧之后再执行 更改角色位置 更改的还会是旧场景的位置
	Game.change_scene(path,{
		entry_point=entry_point
	})
