extends Control

#限制距离
var limit_value:float = 150.0
# 触摸开始位置
var touch_start_position: Vector2 = Vector2.ZERO

enum Dir {Top,Right,Bottom,Left}

var touch_direction = Dir.Top

@onready var dir_img: TextureRect = $VBoxContainer/MarginContainer/Control/DirImg
@onready var dir_label: Label = $VBoxContainer/DirLabel

func _ready() -> void:
	print("ready----")
	dir_img.pivot_offset = dir_img.size / 2
	
func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed:
			#print("触摸点按下: ", event.position)
			# 记录触摸开始位置
			touch_start_position = event.position
		else:
			#print("触摸点移除: ", event.position)
			calc_touch_direction(event)
	#elif event is InputEventScreenDrag:
		#print("触摸点移动: ", event.position)

func calc_touch_direction(event: InputEventScreenTouch):
	# 计算滑动距离
	var touch_end_position = event.position
	var direction = touch_end_position - touch_start_position
	if direction.length() > limit_value:  # 超过阈值
		# 根据向量的方向判断滑动方向
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				print("向右滑动")
				touch_direction = Dir.Right
			else:
				print("向左滑动")
				touch_direction = Dir.Left
		else:
			if direction.y > 0:
				print("向下滑动")
				touch_direction = Dir.Bottom
			else:
				print("向上滑动")
				touch_direction = Dir.Top
		upload_ui()

func upload_ui():
	print("upload_ui",touch_direction)
	match touch_direction:
		0:
			dir_label.text = "向上滑动"
			dir_img.rotation = deg_to_rad(0)
		1:
			dir_label.text = "向右滑动"
			dir_img.rotation = deg_to_rad(90)
		2:
			dir_label.text = "向下滑动"
			dir_img.rotation = deg_to_rad(180)
		3:
			dir_label.text = "向左滑动"
			dir_img.rotation = deg_to_rad(270)	
