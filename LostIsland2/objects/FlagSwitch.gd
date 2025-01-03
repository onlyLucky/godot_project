extends Node2D

# 通过导出flag 来确定展示哪个节点(邮箱实现)

class_name FlagSwitch

@export var flag: String

# flag 不存在时，默认显示的节点
var default_node: Node2D
# flag 存在时，显示的节点
var switch_node: Node2D

func _ready():
	var count := get_child_count()
	if count > 0:
		default_node = get_child(0)
	if count > 1:
		switch_node = get_child(1)
	# 绑定flags 更改信号
	Game.flags.connect("changed", Callable(self, "_update_nodes"))
	_update_nodes()

# 切换更新展示节点
func _update_nodes():
	var exists := Game.flags.has(flag)
	if default_node:
		default_node.visible = !exists
	if switch_node:
		switch_node.visible = exists
