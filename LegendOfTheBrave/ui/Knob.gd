extends TouchScreenButton

# 移动拖动按钮

# 定义拖动范围 16个像素
const DRAG_RADIUS := 16.0

# 还未进行手指交互
var finger_index := -1
# 记录贴图距离触摸点的距离
var drag_offset: Vector2

# 记录初始化位置
@onready var rest_pos := global_position

func _input(event: InputEvent) -> void:
	# 手指点触事件
	var st := event as InputEventScreenTouch
	if st:
		# 判断当前是否点按
		if st.pressed and finger_index == -1:
			# 将视口坐标转化为画布坐标系(画布变换)
			var global_pos := st.position*get_canvas_transform()
			# 将画布坐标系转化为局部坐标系（全局变换）
			var local_pos := global_pos * get_global_transform() # to_local(global_pos)
			# 设置当前贴图大小矩形
			var rect := Rect2(Vector2.ZERO,texture_normal.get_size())
			# 判断当前坐标是否在矩形中	
			if rect.has_point(local_pos):
				# 按下 设置按下的手指的索引号
				finger_index = st.index
				drag_offset = global_pos - global_position
		# 判断当前是否松下手指
		elif not st.pressed and  st.index == finger_index:
			Input.action_release("move_left")
			Input.action_release("move_right")
			finger_index = -1
			global_position = rest_pos
			
			
	# 手指拖拽事件
	var sd := event as InputEventScreenDrag
	if sd and sd.index == finger_index:
		# 拖动
		# 计算拖动范围
		var wish_pos := sd.position * get_canvas_transform() - drag_offset
		var movement := (wish_pos - rest_pos).limit_length(DRAG_RADIUS)
		global_position = rest_pos + movement
		
		# 控制玩家进行移动 计算移动量
		# 归一化 将x轴映射到-1 和 +1 的范围
		movement /= DRAG_RADIUS
		if movement.x > 0:
			Input.action_release("move_left")
			Input.action_press("move_right", movement.x)
		elif movement.x < 0:
			Input.action_release("move_right")
			Input.action_press("move_left", -movement.x)	
		
		
		
		
	
