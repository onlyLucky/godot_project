extends Enemy

enum State {
	IDLE, #站立
	WALK,# 站久了，开始走路
	RUN,# 跑步暴动
	HURT,# 伤害
	DYING,#死亡
}

# 击退速度
const KNOCBACK_AMOUNT := 512.0

# 待处理的伤害对象
var pending_damage: Damage

@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var calm_down_timer: Timer = $CalmDownTimer

# 查看能不能看到用户
func can_see_player() -> bool:
	if not player_checker.is_colliding():
		return false
	# get_collider 获取当前与什么碰撞起来
	return player_checker.get_collider() is Player

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.IDLE,State.HURT,State.DYING:
			move(0.0,delta)
			
		State.WALK:
			move(max_speed / 3,delta)
			
		State.RUN:
			# 暴走状态下，墙面或者悬崖转身继续跑
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				direction *= -1
			move(max_speed,delta)
			# 如果有玩家 ，冷静期定时器打开
			if can_see_player():
				calm_down_timer.start()


# 给当前状态 返回需要更改状态动画
func get_next_state(state: State) -> int:
	# 血量变空， 进入死亡状态
	if stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DYING else State.DYING
	
	# 受伤害
	if pending_damage:
		return State.HURT
		
	match state:
		State.IDLE:
			# 如果检测到玩家，进入暴走状态
			if can_see_player():
				return State.RUN
			# 站久了 2s
			if state_machine.state_time > 2:
				return State.WALK
		
		State.WALK:
			# 如果检测到玩家，进入暴走状态
			if can_see_player():
				return State.RUN
			# 如果前面是墙 或者 前面是悬崖 
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				return State.IDLE
		# 暴走状态
		State.RUN:
			#当前 看不到player 并且冷静期过完
			if not can_see_player() and calm_down_timer.is_stopped():
				return State.WALK
		
		State.HURT:
			if not animation_player.is_playing():
				return State.RUN
	
	return StateMachine.KEEP_CURRENT
	
				
# 根据改变状态 播放相应的状态动画
func transition_state(from: State, to: State) -> void:
	print("[%s] %s => %s" %[
		Engine.get_physics_frames(),
		State.keys()[from] if from != -1 else "<START>",
		State.keys()[to]
	])				
	
	match to:
		State.IDLE:
			animation_player.play("idle")
			# 如果前面是墙壁，立刻转身
			if wall_checker.is_colliding():
				direction *= -1
			
		State.WALK:
			animation_player.play("walk")
			# 如果前面是悬崖， 转身
			if not floor_checker.is_colliding():
				direction *= -1
				# (碰撞检测 会有缓存) force_raycast_update 更新碰撞检测缓存
				floor_checker.force_raycast_update()
			
		State.RUN:
			animation_player.play("run")
			
		State.HURT:
			animation_player.play("hit")
			# 进行扣血， 执行击退效果
			stats.health -= pending_damage.amount
			# 方向  伤害来源位置指向自己位置
			var dir := pending_damage.source.global_position.direction_to(global_position)
			velocity = dir * KNOCBACK_AMOUNT
			
			# 判断是否在背后，调整切图方向
			if dir.x > 0:
				direction = Direction.LEFT
			else:
				direction = Direction.RIGHT
			
			pending_damage = null
			
		State.DYING:
			animation_player.play("die")


# 收到攻击
func _on_hurtbox_hurt(hitbox: Variant) -> void:
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
	#stats.health -= 1
	#if stats.health <= 0:
		#queue_free() # 野猪受到伤害 释放队列 野猪消失
