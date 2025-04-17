extends Node
class_name StateBase

var state_name : String = "StateBase"

# 抽象类

#进入
func enter(msg: Dictionary={}) -> void:
	pass
	
#退出
func exit() -> void:
	pass

# 每一帧更新
func update(delta) -> void:
	pass

# 每一个物理帧更新
func physics_update(delta) -> void:
	pass
