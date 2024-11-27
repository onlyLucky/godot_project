@tool
extends Resource

# H2A 场景 移动旗子小游戏逻辑
class_name H2AConfig

# 这里是壁纸上面固定 符号 从底部空 顺时针 枚举值以0开始
enum Slot { NULL, TIME, SUN, FISH, HILL, CROSS, CHOICE }

#@export var placements := []
var placements := []
# 位置和位置之间的连接关系
#@export var connections := {}
var connections := {}

# 初始化类 添加过@tool 才会走_init
func _init():
	# 初始化旗子空间
	placements.resize(Slot.size())
	placements.fill(Slot.NULL)
	
	for slot in Slot.values():
		connections[slot] = []
	print("placements: ",placements)

# godot 自带 export 返回自定义导出数据类型
func _get_property_list():
	var properties := [
		{
			name="placements",
			type=TYPE_ARRAY,
			usage=PROPERTY_USAGE_STORAGE,# 单独用来存储，不用显示
		},
		{
			name="connections",
			type=TYPE_DICTIONARY,
			usage=PROPERTY_USAGE_STORAGE,# 单独用来存储，不用显示
		}
	]
	# 制作一个枚举name 从1开始展示
	
	var options :String= Slot.keys().reduce(func(a,item):
		return "%s,%s" % [a,item];
	)
	for slot in range(1, Slot.size()):
		properties.append({
			"name": "placements/" + Slot.keys()[slot],# 放在placements 分组下面
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_EDITOR,#设置当前显示在检查其中，但不可以编辑
			"hint": PROPERTY_HINT_ENUM, #表示value 是一个枚举 有限数据
			"hint_string": options, # 下拉选择项 "A,B,C,D" 
		})
	
	for slot in Slot.size() - 1:
		var available = []
		for dst in Slot.size():
			if dst <= slot:
				available.append("")
			else:
				available.append(Slot.keys()[dst])
		
		var cOptions :String= available.reduce(func(a,item):
			return "%s,%s" % [a,item];
		)
		#print("available: =",available,"cOptions: =",cOptions)
		properties.append({
			"name": "connections/" + Slot.keys()[slot],# 放在placements 分组下面
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_EDITOR,#设置当前显示在检查其中，但不可以编辑
			"hint": PROPERTY_HINT_FLAGS, #表示value 是一个多选
			"hint_string": cOptions, # 下拉选择项 "A,B,C,D" 
		})
	return properties

#
func _get(property):
	# 查询前缀有placements/
	if property.begins_with("placements/"):
		# 去除前缀
		property = property.trim_prefix("placements/")
		var index := Slot[property] as int
		return placements[index]
	if property.begins_with("connections/"):
		# 去除前缀
		property = property.trim_prefix("connections/")
		var index := Slot[property] as int
		var value = 0
		for dst in range(index+1, Slot.size()):
			# 判断当前是否为相连
			if dst in connections[index]:
				value |= (1 << dst) # 将dst位 设置为1
		return value

func _set(property, value):
	if property.begins_with("placements/"):
		property = property.trim_prefix("placements/")
		var index := Slot[property] as int
		placements[index] = value
		emit_changed()
		return true
	
	if property.begins_with("connections/"):
		property = property.trim_prefix("connections/")
		var index := Slot[property] as int
		for dst in range(index+1, Slot.size()):
			#value & (1 << dst) 取决于 value dst位是0还是1
			_set_connected(index,dst,value & (1 << dst))
		emit_changed()
		return true
		
	return false

# 设置连接 src： 连接是从哪里连上的   dst： 连到哪里去  connected: 是否相连
func _set_connected(src: int,dst: int, connected: bool):
	var src_arr := connections[src] as Array
	var dst_arr := connections[dst] as Array
	var src_idx := src_arr.find(dst)
	var dst_idx := dst_arr.find(src)
	if connected:
		if src_idx == -1:
			src_arr.append(dst)
		if dst_idx == -1:
			dst_arr.append(src)
	else:
		if src_idx != -1:
			src_arr.remove_at(src_idx)
		if dst_idx != -1:
			dst_arr.append(dst_idx)
	
