@tool
extends Interactable
class_name Teleporter

# 传送器

#export_file 导出为文件选择
@export_file("*.tscn") var target_path: String

func _interact():
	super()
	#get_tree().change_scene_to_file(target_path)
	SceneChanger.change_scene(target_path)
