extends World

# 当野怪死亡事件
func _on_boar_died() -> void:
	# 等待一秒之后
	await get_tree().create_timer(1).timeout
	# 切换游戏成功通关场景
	Game.change_scene("res://ui/game_end_screen.tscn",{
		duration=1.0,
	})
