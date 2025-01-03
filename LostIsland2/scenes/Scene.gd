extends Sprite2D
class_name Scene

@export_file("*.mp3") var music_override: String = ""

func _ready():
	# 创建补间动画 缩放转场
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"scale", Vector2.ONE,0.3).from(Vector2.ONE * 1.05)
	print("get_tree().current_scene.filename", get_path())

func _get_name():
	print("get_tree().current_scene.filename", get_path())
