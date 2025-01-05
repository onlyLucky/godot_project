extends PanelContainer

# 场景类型
@export var PACK_BASE_PANEL:PackedScene

@onready var hfc_main: HFlowContainer = %HFC_Main

# 多线程对象
var thread_helper:ThreadHelper

func _ready() -> void:
	clear()
	thread_helper = ThreadHelper.new(self)

# 初始化右侧文件列表
func init_from_files(files: Array):
	clear()
	if not files:
		return
	thread_helper.end()
	for file in files:
		new_panel(file)
	thread_helper.start()

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

# Signals 面板点击绑定事件 panel 为右侧单个文件item
func _on_panel_pressed(panel: BasePanel):
	var image_path = panel.get_meta("image_path")
	# 获取每一个点击项，打开文件
	OS.shell_open(image_path)

# 从线程中加载image
func add_image_from_thread(panel, image_path):
	var image = Image.load_from_file(image_path)
	var texture = ImageTexture.create_from_image(image)
	# 有些节点的函数在thread没办法调用 在空闲帧去调用函数
	panel.call_deferred("set_image",texture)
	
