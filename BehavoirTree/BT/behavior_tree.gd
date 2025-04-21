extends Node
class_name BehaviorTree

var is_hunger: bool = false

func _ready() -> void:
	get_child(0).run()
