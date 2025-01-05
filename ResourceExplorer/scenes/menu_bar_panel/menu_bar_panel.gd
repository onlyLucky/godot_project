extends PanelContainer

# 文件选择后信号
signal folder_selected(dir_path:String)

@onready var menu_file: PopupMenu = %File
@onready var menu_edit: PopupMenu = %Edit
@onready var menu_help: PopupMenu = %Help

#文件菜单项
enum MenuFile {Open}

func _ready() -> void:
	init_menu_file()

# 初始化文件菜单项
func init_menu_file():
	menu_file.clear()
	menu_file.add_item("Open",MenuFile.Open)
	menu_file.id_pressed.connect(call_menu_file)

# 绑定文件菜单 点击事件
func call_menu_file(id: int):
	if id == MenuFile.Open:
		# 打开文件，文件夹选择器
		DisplayServer.file_dialog_show(
			"open folder",
			"",
			"",
			false,
			DisplayServer.FILE_DIALOG_MODE_OPEN_DIR,
			["*.png","*.jpg","*.tiff"],
			_on_folder_selected
		)

# 当文件选择器选择之后回调函数。
func _on_folder_selected(status: bool, selected_paths: PackedStringArray,selected_filter_index: int):
	if not status:
		return
	folder_selected.emit(selected_paths[0])
	print(selected_paths)
