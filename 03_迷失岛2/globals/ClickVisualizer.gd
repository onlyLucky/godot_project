extends CanvasLayer


func _ready():
	layer = 99
	
func _input(event):
	if not event.is_action_pressed("interact"):
		return
	var sprite := Sprite2D.new()
	add_child(sprite)
	sprite.texture = preload("res://assets/UI/click.svg")
	sprite.global_position = get_viewport().get_mouse_position()
	
	# 设置过度动画 缩放透明度消失出现
	var tween := create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.3).from(Vector2.ONE * 0.9)
	tween.parallel().tween_property(sprite, "modulate:a", 1.0, 0.2).from(0.0)
	tween.tween_property(sprite,"modulate:a",0.0,0.3)
	tween.tween_callback(sprite.queue_free)
