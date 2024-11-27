extends FlagSwitch


# 信箱场景代码逻辑

# 关闭信箱交互信号，使用钥匙打开信箱
func _on_interactable_interact():
	var item: Item= Game.inventory.active_item
	# 判断当前没有选择的道具 或者使用的道具不是钥匙 不执行
	if !item or item != preload("res://items/key.tres"):
		return
	# 添加信箱打开的flag 移除道具栏的钥匙 
	Game.flags.add(flag)
	Game.inventory.remove_item(item)
