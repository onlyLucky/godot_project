@tool
extends Node2D

# 小游戏的逻辑

const SLOT_TEXTURE = preload("res://assets/H2A/CIRCLE.png") #棋子圆圈位置贴图
const LINE_TEXTURE = preload("res://assets/H2A/CIRCLELINE.png") #棋子连线贴图

@export var radius :float= 100.0:
	set(v):
		radius = v
		#queue_redraw() #强制场景重绘
		notify_property_list_changed()
		print("notify_property_list_changed")
		
@export var config:H2AConfig:
	set(v):
		if config and config.is_connected("changed",Callable(self, "_update_board")):
			config.disconnect("changed",Callable(self, "_update_board"))
		config = v
		if config and not config.is_connected("changed",Callable(self, "_update_board")):
			config.connect("changed", Callable(self, "_update_board"))
		_update_board()
		
var _stone_map := {} #记录所有的stone

# 绘制每一个棋子贴图
func _draw():
	for slot in H2AConfig.Slot.size():
		draw_texture(SLOT_TEXTURE, _get_slot_position(slot) - SLOT_TEXTURE.get_size()/2) # 绘制的坐标位置为左上角
		

func _get_slot_position(slot: int)->Vector2:
	# TAU 2π  后面乘以radius半径  相当于 一单位向量的乘以radius
	return Vector2.DOWN.rotated(TAU / H2AConfig.Slot.size() * slot) * radius
	

#设置棋盘
func _update_board():
	for node in get_children():
		if node.owner == null:
			node.queue_free()
	
	if !config:
		return
	
	# 更新连线
	for src in H2AConfig.Slot.size():
		for dst in range(src + 1, H2AConfig.Slot.size()):
			if not dst in config.connections[src]:
				continue
			var line := Line2D.new()
			add_child(line)
			line.add_point(_get_slot_position(src))
			line.add_point(_get_slot_position(dst))
			line.width = LINE_TEXTURE.get_size().y
			line.texture = LINE_TEXTURE
			line.texture_mode = Line2D.LINE_TEXTURE_TILE # 设置平铺展示
			line.default_color = Color.WHITE
			line.show_behind_parent = true #设置在父节点的后面
	
	# 更新棋子
	for slot in range(1, H2AConfig.Slot.size()):
		var stone := H2AStone.new()
		add_child(stone)
		stone.target_slot = slot
		stone.current_slot = config.placements[slot]
		stone.position = _get_slot_position(stone.current_slot)
		_stone_map[slot] = stone #记录棋子
		stone.connect("interact",Callable(self, "_request_move").bind(stone))
		

# 
func _request_move(stone: H2AStone):
	# 七个位置， 默认有六个位置为棋子， 只有一个空位（找出空位）
	var available := H2AConfig.Slot.values()
	for s in _stone_map.values():
		available.erase(s.current_slot) # 移除所有当前所在位置
	assert(available.size() == 1)
	var available_slot := available.front() as int
	if available_slot in config.connections[stone.current_slot]:
		_move_stone(stone, available_slot)
		
# 移动棋子
func _move_stone(stone: H2AStone, slot: int):
	stone.current_slot = slot
	# 添加动画
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(stone, "position", _get_slot_position(slot),0.2)
	# 等待1.5s 判断所有棋子是否移动到争取的位置上面
	tween.tween_interval(1.0)
	tween.tween_callback(self._check)


# 检查是否通关
func _check():
	for stone in _stone_map.values():
		if stone.current_slot != stone.target_slot:
			return
	
	# 游戏通关
	Game.flags.add("h2a_unlocked")
	SceneChanger.change_scene("res://scenes/H2.tscn")
	

# 重置
func reset():
	for stone in _stone_map.values():
		_move_stone(stone,config.placements[stone.target_slot])
