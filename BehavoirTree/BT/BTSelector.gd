extends Node
class_name BTSelector

signal successed
signal failed

func _ready() -> void:
	for c in get_children():
		c.connect()

func run() -> void:
	get_child(0).run()
