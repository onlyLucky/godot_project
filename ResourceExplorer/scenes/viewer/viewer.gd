extends PanelContainer

# 场景类型
@export var PACK_BASE_PANEL:PackedScene

@onready var hfc_main: HFlowContainer = %HFC_Main
@onready var page_manager: PanelContainer = $VBoxContainer/PageManager as PageManager
@onready var label_info: Label = $VBoxContainer/MarginContainer2/LabelInfo

# 多线程对象
var thread_helper:ThreadHelper
# 图片最大宽度
var image_max_size := 200

var all_files := []

func _ready() -> void:
	page_manager.page_changed.connect(show_page_files)
	thread_helper = ThreadHelper.new(self)
	clear()
	page_manager.set_each_page_item_count(10)

# 初始化右侧文件列表
func init_from_files(files: Array):
	all_files = files
	page_manager.set_total_item_count(len(files))

func create_panel_from(files: Array):
	clear()
	if not files:
		return
	thread_helper.end()
	for file in files:
		new_panel(file)
	thread_helper.start()

# 文件页数更改
func show_page_files():
	create_panel_from(page_manager.get_items(all_files))
	update_label_info()
	

func update_label_info():
	label_info.show()
	label_info.text = "total count: %d, page size: %d" %[page_manager.total_item_count, page_manager.each_page_item_count]

# 清除右侧文件面板基础场景
func clear():
	for child in hfc_main.get_children():
		child.queue_free()

func add_panel(panel:BasePanel):
	hfc_main.add_child(panel)
	
func new_panel(image_path: String):
	var panel = PACK_BASE_PANEL.instantiate() as BasePanel
	add_panel(panel)
	
	#var image = Image.load_from_file(image_path)
	#var texture = ImageTexture.create_from_image(image)
	#panel.set_image(texture)
	panel.set_title(image_path.get_file())
	panel.set_meta("image_path",image_path)
	# 右侧面板点击事件绑定
	panel.pressed.connect(_on_panel_pressed.bind(panel))
	
	thread_helper.join_function(func(): 
		add_image_from_thread(panel,image_path)
	)
	
	return panel

# 从线程中加载image
func add_image_from_thread(panel, image_path):
	var image = Image.load_from_file(image_path)
	if image == null:
		print("Failed to load image from path:", image_path)
		return
	# 优化图片加载 更改为缩略图
	image = scale_down(image, image_max_size)
	var texture = ImageTexture.create_from_image(image)
	# 有些节点的函数在thread没办法调用 在空闲帧去调用函数
	panel.call_deferred("set_image",texture)

# 图片缩略图处理函数
func scale_down(image: Image, max_size: int):
	var image_size = image.get_size()
	# 获取图片长宽比
	var image_aspect = image_size.aspect()
	if max(image_size.x,image_size.y) <= max_size:
		return image
	var new_w = 0
	var new_h = 0
	if image_aspect > 1: #w>h
		new_w = max_size
		new_h = max_size/image_aspect
	else:
		new_w = max_size*image_aspect
		new_h = max_size
	image.resize(new_w,new_h)
	return image

## Signals
# 面板点击绑定事件 panel 为右侧单个文件item
func _on_panel_pressed(panel: BasePanel):
	var image_path = panel.get_meta("image_path")
	# 获取每一个点击项，打开文件
	OS.shell_open(image_path)
	
