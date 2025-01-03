extends CanvasLayer

# 进入游戏
signal game_entered
# 退出游戏
signal game_exited

# 转场逻辑
@onready var color_rect = $ColorRect

func _ready():
	# 刚开始播放bgm
	_on_scene_changed(null, get_tree().current_scene)

# 创建补间动画 进行转场
func change_scene(path: String):
	var tween = create_tween()
	tween.tween_callback(color_rect.show)
	tween.tween_property(color_rect, "color:a", 1.0, 0.2)
	#tween.tween_callback(get_tree().change_scene_to_file.bind(path))
	tween.tween_callback(self._change_scene.bind(path))
	tween.tween_property(color_rect, "color:a", 0.0, 0.3)
	tween.tween_callback(color_rect.hide)

# 手动设置切换场景 change_scene_to_file 只会在空闲帧中处理
func _change_scene(path: String):
	var old_scene := get_tree().current_scene
	var new_scene := load(path).instantiate() as Node
	
	var root := get_tree().root
	root.remove_child(old_scene)
	root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	_on_scene_changed(old_scene,new_scene)
	
	# 原来的场景释放
	old_scene.queue_free()

func _on_scene_changed(old_scene: Node,new_scene: Node):
	# 判断当前是什么场景
	var was_in_game := old_scene is Scene
	var is_in_game := new_scene is Scene
	if was_in_game != is_in_game:
		if is_in_game:
			emit_signal("game_entered")
		else:
			emit_signal("game_exited")
	
	# 背景音乐播放切换
	var music := "res://assets/Music/PaperWings.mp3"
	if is_in_game and new_scene.music_override:
		music = new_scene.music_override
	SoundManager.play_music(music)
	
