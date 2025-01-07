extends Node

var user_data := UserData.new()
var save_path := "user://user_data.tres"

func save_data():
	ResourceSaver.save(user_data,save_path)

func load_data():
	if not FileAccess.file_exists(save_path):
		return
	user_data = ResourceLoader.load(save_path,"UserData")
	print(user_data)

func _notification(what: int) -> void:
	# 监听到程序结束的信号时候
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.save_data()
