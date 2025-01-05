extends Control

@onready var files_manager: PanelContainer = %FilesManager
@onready var viewer: PanelContainer = %Viewer
@onready var menu_bar_panel: PanelContainer = $PanelContainer/VBoxContainer/MenuBarPanel

var image_extensions = ["png","jpg","tiff","svg"]

func _ready() -> void:
	menu_bar_panel.folder_selected.connect(files_manager.set_file_path)
	files_manager.directory_changed.connect(_on_directory_changed)
	

# 当前选中文件夹改变调用函数
func _on_directory_changed():
	var files = files_manager.get_current_directory_files()
	var images = filter_images(files)
	viewer.init_from_files(images)

# 过滤类型文件
func filter_images(files:Array) -> Array:
	var f_files = []
	for file in files:
		if file.get_extension() in image_extensions:
			f_files.append(file)
	return f_files
