extends CharacterBody2D

signal health_depleted

var health = 100.0

func _physics_process(delta):
	# 定义方向变量
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	# 定义速度
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0: # 速度向量大于0 说明在移动
		$HappyBoo.play_walk_animation() # 获取HappyBoo节点执行走路动画
	else:
		$HappyBoo.play_idle_animation() # 获取HappyBoo节点执行走路动画
	
	# 伤害计算 每秒伤害 获取重叠区域
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			# 发送游戏结束消息
			health_depleted.emit()

