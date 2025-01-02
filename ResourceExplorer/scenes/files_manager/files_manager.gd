extends PanelContainer
#左侧结构

# 文件夹改变的信号
signal directory_changed

@onready var tree: Tree = %Tree

var root: TreeItem

# 文件地址
@export var file_path: String:
	set(value):
		file_path = value
		if is_inside_tree():
			init_file_path()
#tree 文件夹图标
@export var ICON_FOLDER: Resource

func _ready() -> void:
	tree.hide_root = true
	file_path = "E:/uploadFiles"
	tree.item_selected.connect(_on_item_selected)

# 修改  外部file_path init
func init_file_path():
	tree.clear()
	root = tree.create_item()
	print(root)
	if not file_path or not DirAccess.dir_exists_absolute(file_path):
		return
	create_tree_from_dir(root,file_path)

# 以下是遍历目录中文件的示例：
func create_tree_from_dir(parent:TreeItem, directory: String)->void:
	var dir = DirAccess.open(directory)
	if dir:
		for sub_dir in dir.get_directories():
			#创建tree 子节点
			var sub_tree_item = tree.create_item(parent) as TreeItem
			# 设置图标
			sub_tree_item.set_icon(0,ICON_FOLDER)
			sub_tree_item.set_icon_max_width(0, 24)
			# 设置文本
			sub_tree_item.set_text(0, sub_dir)
			
			var sub_dir_path = directory+"/"+sub_dir
			sub_tree_item.set_metadata(0,sub_dir_path)
			create_tree_from_dir(sub_tree_item, sub_dir_path)
			
	else:
		print("尝试访问路径时出错。")

# 监听tree 某一项选中
func _on_item_selected():
	directory_changed.emit()

# 获取当前点击文件夹
func get_current_directory():
	var current_item := tree.get_selected() as TreeItem
	if current_item:
		return current_item.get_metadata(0)

