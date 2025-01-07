extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(value: String):
	if value == "start_in":
		animation_player.play("start_out")
	if value == "start_out":
		get_tree().change_scene_to_file("res://scenes/application.tscn")
