class_name Interactable

# 可交互节点
extends Area2D

# 交互信号
signal interacted

func _init() -> void:
	# 设置当前处于哪个层位域 能和哪个层位域交互
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	
	# 当接收到的 body 进入这个区域时发出的
	body_entered.connect(_on_body_entered)
	# 当接收到的 body 离开这个区域时发出的。
	body_exited.connect(_on_body_exited)
	

func interact() -> void:
	print("[Interact] %s" % name)
	interacted.emit()


func _on_body_entered(player: Player) -> void:
	player.register_interactable(self)
	
func _on_body_exited(player: Player) -> void:
	player.unregister_interactable(self)
