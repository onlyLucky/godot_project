extends AnimatedSprite2D
# 根据设备不同显示不一样的动画

# 触屏设备
#DisplayServer.is_touchscreen_available()

# 触发遥杆事件死区
const STICK_DEADZONE := 0.3
# 鼠标移动速度死区
const MOUSE_DEADZONE := 16

func _ready() -> void:
	# 获取手柄的列表
	if Input.get_connected_joypads():
		# 使用默认手柄
		show_joyed_icon(0)
	else:
		play("Keyboard")

func _input(event: InputEvent) -> void:
	# 判断玩家是否按下了手柄按钮 或者碰到了手柄遥杆 event.axis_value -+1
	if(
		event is InputEventJoypadButton or 
		(event is InputEventJoypadMotion and abs(event.axis_value) > STICK_DEADZONE)
	):
		show_joyed_icon(event.device)
	
	if(
		event is InputEventKey or 
		event is InputEventMouseButton or 
		(event is InputEventJoypadMotion and event.velocity.length() > MOUSE_DEADZONE)
	):
		play("Keyboard")
		

# 判断当前手柄设备 厂商 这个不是完全准确的， 可以在设置中添加关闭自动获取，手动设置手柄类型
func show_joyed_icon(device: int) -> void:
	var joyped_name := Input.get_joy_name(device)
	
	if "Nintendo" in joyped_name:
		play("nintende") # 任天堂
	elif "DualShock" in joyped_name or "PS" in joyped_name:
		play("nintende") # PlayStation
	else:
		play("nintende") # Xbox
