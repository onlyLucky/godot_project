extends Node

#定义存档文件存放位置
const SAVE_PATH := "user://data.sav"

# 全局使用 用来记录道具被拾取的状态
class Flags:
	
	signal changed
	
	var _flags := []
	
	func has(flag: String)->bool:
		return flag in _flags
	
	func add(flag: String):
		if flag in _flags:
			return
		_flags.append(flag)
		emit_signal("changed")
		
	# 添加游戏读取保存 重置
	func to_dict():
		return {
			flags=_flags
		}
	
	func from_dict(dict: Dictionary):
		_flags = dict.flags
		emit_signal("changed")
	
	func reset():
		_flags.clear()
		emit_signal("changed")

# 全局使用 用来记录背包道具的管理类
class Inventory:
	signal changed
	
	var active_item: Item # 当前被激活的道具
	
	var _items := [] #道具列表
	var _curren_item_index := -1 #当前道具
	
	func get_item_count() ->int:
		return _items.size()
		
	func get_current_item() -> Item:
		if _curren_item_index == -1:
			return null
		return _items[_curren_item_index]
		
	func add_item(item: Item):
		if item in _items:
			return
		_items.append(item)
		_curren_item_index = _items.size() - 1
		emit_signal("changed")
	
	func remove_item(item: Item):
		var index := _items.find(item)
		if index == -1:
			return
		_items.remove_at(index)
		if _curren_item_index >= _items.size():
			_curren_item_index = 0
		if _items.size()<=0:
			_curren_item_index = -1
		emit_signal("changed")
		
	func select_next():
		if _curren_item_index == -1:
			return
		_curren_item_index = (_curren_item_index + 1) % _items.size()
		emit_signal("changed")
	
	func select_prev():
		if _curren_item_index == -1:
			return
		_curren_item_index = (_curren_item_index - 1 + _items.size()) % _items.size()
		emit_signal("changed")
	
	# 添加游戏读取保存 重置
	func to_dict():
		var names := []
		for item in _items:
			var path := item.resource_path as String
			names.append(path.get_file().get_basename())
		return {
			items = names,
			curren_item_index = _curren_item_index
		}
	
	func from_dict(dict: Dictionary):
		_curren_item_index = dict.curren_item_index
		_items.clear()
		for name in dict.items:
			_items.append(load("res://items/%s.tres" % name))
		emit_signal("changed")
	
	func reset():
		_curren_item_index = -1
		_items.clear()
		emit_signal("changed")

var flags := Flags.new()
var inventory = Inventory.new()

# 保存游戏
func save_game():
	var file := FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	if file == null :
		return
	var data := {
		"inventory":inventory.to_dict(),
		"flags":flags.to_dict(),
		"current_scene":get_tree().current_scene.scene_file_path,
	}
	var json := JSON.stringify(data)
	file.store_string(json)
	print("get_tree().current_scene: ",get_tree().current_scene.scene_file_path)
	
# 读取文件
func load_game():
	var file := FileAccess.open(SAVE_PATH,FileAccess.READ)
	if file == null :
		return
	var json := file.get_as_text()
	var data = JSON.parse_string(json) as Dictionary
	inventory.from_dict(data.inventory)
	flags.from_dict(data.flags)
	SceneChanger.change_scene(data.current_scene)
	
# 新游戏
func new_game():
	inventory.reset()
	flags.reset()
	SceneChanger.change_scene("res://scenes/H1.tscn")

# 判断当前存档文件是否存在
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

# 返回首页
func back_to_title():
	SceneChanger.change_scene("res://ui/TitleScreen.tscn")
