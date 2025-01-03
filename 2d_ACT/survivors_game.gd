extends Node2D

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true

func start():
	%Player.start($StartPosition.position)
	%GameOver.visible = false
	#get_tree().call_group("mobs","queue_free")



func _on_start_game_pressed():
	print("_on_start_game_pressed")
	start()
