extends Area2D


func _physics_process(delta):
	# 获取射程区域内的物体
	var enmies_in_range = get_overlapping_bodies()
	if enmies_in_range.size() > 0:
		var target_enemy = enmies_in_range.front() # enmies_in_range[0]
		look_at(target_enemy.global_position)


func shoot():
	# preload 预加载 load执行到当前代码，才会执行
	const BULLET = preload("res://bullet.tscn")
	# 新建子弹实例 设置位置 将子弹添加到ShootingPoint
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)


func _on_timer_timeout():
	shoot()
