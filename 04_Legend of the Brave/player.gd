class_name Player
extends CharacterBody2D

# Player 状态动画
enum State {
	IDLE,#站立
	RUNNING,#跑步
	JUMP,#跳跃
	FALL,#下落
	LANDING,#着陆
	WALL_SLIDING,#滑墙
	WALL_JUMP,#蹬墙跳
	ATTACK_1,#攻击
	ATTACK_2,
	ATTACK_3,
	HURT,#伤害
	DYING,#死亡
	SLIDING_START, #开始滑铲
	SLIDING_LOOP, #滑铲中
	SLIDING_END,#结束滑铲
}
# 在地板上状态动画
const GROUND_STATES := [
	State.IDLE,State.RUNNING,State.LANDING,
	State.ATTACK_1,
	State.ATTACK_2,
	State.ATTACK_3,
]

# 跑步速度
const RUN_SPEED := 160.0
# 跳起速度 负数由于y轴向下
const JUMP_VELOCITY := -320.0
# 跑起来的加速度
const FLOOR_ACCELERATION := RUN_SPEED / 0.2
# 空中转向移动加速度
const AIR_ACCELERATION := RUN_SPEED / 0.1
# 蹬墙跳方向变量
const WALL_JUMP_VELOCITY := Vector2(380,-280)
# 击退速度
const KNOCBACK_AMOUNT := 512.0
# 滑铲中 进入到下一个动画 持续时间
const SLIDING_DURATION := 0.3
# 滑铲 loop 速度
const SLIDING_SPEED := 256.0

#是否连击
@export var can_combo := false

# 获取默认加速度
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float
# 判断当前是否为第一帧动画
var is_first_tick := false
# 判断当前是否为连击
var is_combo_requested := false
# 待处理的伤害对象 应该为数组
var pending_damage: Damage

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var hand_checker: RayCast2D = $Graphics/HandChecker
@onready var foot_checker: RayCast2D = $Graphics/FootChecker
@onready var state_machine: StateMachine = $StateMachine
@onready var stats: Stats = $Stats
@onready var invincible_timer: Timer = $InvincibleTimer


# 判断当前输入时间
func _unhandled_input(event: InputEvent) -> void:
	# 判断当前是否按下了jump
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	# 判断当前是否松下了jump(根据按jump键松开的 velocity.y 如果比 跳跃一半距离还少，更改跳跃高度为一半)
	if event.is_action_released("jump") and velocity.y < JUMP_VELOCITY / 2:
		velocity.y = JUMP_VELOCITY / 2
	
	# 判断是否为攻击键
	if event.is_action_pressed("attack") and can_combo:
		is_combo_requested = true
		

func tick_physics(state: State, delta: float) -> void:
	# 无敌2s 更改透明度 一闪一闪
	if invincible_timer.time_left>0:
		# 随机产生0-1
		graphics.modulate.a = sin(Time.get_ticks_msec()/50) * 0.5 + 0.5
	else:
		graphics.modulate.a = 1
		
	match state:
		State.IDLE:
			move(default_gravity,delta)
			
		State.RUNNING:
			move(default_gravity,delta)
			
		State.JUMP:
			# 去除第一帧重力对起跳高度影响
			move(0.0 if is_first_tick else default_gravity,delta)
			
		State.FALL:
			move(default_gravity,delta)
			
		State.LANDING:
			# 着陆站立动画
			stand(default_gravity,delta)
			
		State.WALL_SLIDING:
			move(default_gravity / 3,delta)
			# 设置滑墙方向 get_wall_normal 获得最近墙体的法线 -1 +1
			graphics.scale.x = get_wall_normal().x
		
		State.WALL_JUMP:
			# 判断当前持续时间小于0.1 站立， 翻转
			if state_machine.state_time < 0.1:
				stand(0.0 if is_first_tick else default_gravity,delta)
				graphics.scale.x = get_wall_normal().x
			else:
				# 开始蹬墙跳 这里肯定不是第一帧就不用去除第一帧重力对起跳高度影响
				move(default_gravity,delta)
		
		State.ATTACK_1,State.ATTACK_2,State.ATTACK_3:
			stand(default_gravity,delta)
		
		State.HURT,State.DYING:
			stand(default_gravity,delta)
			
		State.SLIDING_END:
			stand(default_gravity,delta)
		
		State.SLIDING_START,State.SLIDING_LOOP:
			# 使用固定的速度 向一个方向移动 不受玩家按键控制
			slide(delta)
			
	# 执行完成设置第一帧已经结束
	is_first_tick = false
	

func move(gravity: float, delta: float)-> void:
	# 左右位移
	var direction := Input.get_axis("move_left","move_right") # 1， -1
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	# move_toward 添加速度过渡 from to delta(速度变化量 = 加速度*时间)
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta) #
	velocity.y += gravity * delta
	
	# 角色翻转
	if not is_zero_approx(direction):
		#sprite_2d.flip_h = direction<0
		graphics.scale.x = -1 if direction < 0 else +1
		
	# 开始移动
	move_and_slide()


func stand(gravity: float, delta: float)-> void:
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	# move_toward 添加速度过渡 from to delta(速度变化量 = 加速度*时间)
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta) # to 更改为0 排除运动速度影响
	velocity.y += gravity * delta
	
	# 开始移动
	move_and_slide()
	
func slide(delta: float)-> void:
	# 速度
	velocity.x = graphics.scale.x * SLIDING_SPEED
	velocity.y += default_gravity * delta
	
	# 开始移动
	move_and_slide()

# 玩家死亡
func die() -> void:
	# 重新调用当前场景
	get_tree().reload_current_scene()

# 是否滑墙下落
func can_wall_slide() -> bool:
	return is_on_wall() and hand_checker.is_colliding() and foot_checker.is_colliding()

# 是否可以滑铲
func should_slide() -> bool:
	if not Input.is_action_just_pressed("slide"):
		return false
	# 当前player 脚部没有碰到墙体
	return not foot_checker.is_colliding()

# 给当前状态 返回需要更改状态动画
func get_next_state(state: State) -> int:
	# 血量变空， 进入死亡状态
	if stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DYING else State.DYING
	# 受伤害
	if pending_damage:
		return State.HURT
		
	# 是否能跳跃
	var can_jump := is_on_floor() or coyote_timer.time_left > 0
	# 是否为主动跳跃
	var should_jump := can_jump and jump_request_timer.time_left > 0
	
	# 跳跃
	if should_jump:
		return State.JUMP
		
	# 在地面上面运动,如果不在地板上（走路，往下掉）
	if state in GROUND_STATES and not is_on_floor():
		return State.FALL
	
	# 是否左右位移
	var direction := Input.get_axis("move_left","move_right")
	# 是否站立不动的
	var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
	match state:
		State.IDLE:
			# 判断当前是否点击攻击
			if Input.is_action_just_pressed("attack"):
				return State.ATTACK_1
			# 判断当前是否点击滑铲
			if should_slide():
				return State.SLIDING_START
			if not is_still:
				return State.RUNNING
			
		State.RUNNING:
			# 判断当前是否点击攻击
			if Input.is_action_just_pressed("attack"):
				return State.ATTACK_1
			# 判断当前是否点击滑铲
			if should_slide():
				return State.SLIDING_START
			if is_still:
				return State.IDLE
			
		State.JUMP:
			if velocity.y >= 0:
				return State.FALL
			
		State.FALL:
			if is_on_floor():
				# 下落只有当前站立不左右移动 State.LANDING 否则播放 runing
				return State.LANDING if is_still else State.RUNNING
			# 检测是否与墙体碰撞 检测手部脚部碰撞检测
			if can_wall_slide():
				return State.WALL_SLIDING
		
		State.LANDING:
			#去除着陆到跑步的 动作硬直
			if not is_still:
				return State.RUNNING
			# 判断当前着陆动画是否播放完成
			if not animation_player.is_playing():
				return State.IDLE if is_still else State.RUNNING
		
		State.WALL_SLIDING:
			if jump_request_timer.time_left > 0:
				return State.WALL_JUMP
			if is_on_floor():
				return State.IDLE
			if not is_on_wall():
				return State.FALL
				
		State.WALL_JUMP:
			if can_wall_slide() and not is_first_tick:
				return State.WALL_SLIDING
			if velocity.y >= 0:
				return State.FALL
		# 第一段攻击
		State.ATTACK_1:
			if not animation_player.is_playing():
				return State.ATTACK_2 if is_combo_requested else State.IDLE
		# 第二段攻击
		State.ATTACK_2:
			if not animation_player.is_playing():
				return State.ATTACK_3 if is_combo_requested else State.IDLE
		# 第三段攻击
		State.ATTACK_3:
			if not animation_player.is_playing():
				return State.IDLE
		
		# 受到伤害
		State.HURT:
			if not animation_player.is_playing():
				return State.IDLE
		
		# 开始滑铲
		State.SLIDING_START:
			# 动画播放完成
			if not animation_player.is_playing():
				return State.SLIDING_LOOP
				
		# 结束滑铲
		State.SLIDING_END:
			# 动画播放完成
			if not animation_player.is_playing():
				return State.IDLE
		
		# 滑铲中
		State.SLIDING_LOOP:
			# 滑铲中动画持续了多久之后 进入到 结束滑铲 或者 遇到了墙体
			if state_machine.state_time > SLIDING_DURATION or is_on_wall():
				return State.SLIDING_END
		
	return StateMachine.KEEP_CURRENT


# 根据改变状态 播放相应的状态动画
func transition_state(from: State, to: State) -> void:
	print("[%s] %s => %s" %[
		Engine.get_physics_frames(),
		State.keys()[from] if from != -1 else "<START>",
		State.keys()[to]
	])
	# 从不在地上的状态动画 并且 落在了地上 停掉郊狼时间
	if from not in GROUND_STATES and to in GROUND_STATES:
		coyote_timer.stop()
		
		
	match to:
		State.IDLE:
			animation_player.play("idle")
			
		State.RUNNING:
			animation_player.play("running")
			
		State.JUMP:
			animation_player.play("jump")
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()
			jump_request_timer.stop()
			
		State.FALL:
			animation_player.play("fall")
			# 判断是否从地板上开始下落的 开始郊狼时间
			if from in GROUND_STATES:
				coyote_timer.start()
		State.LANDING:
			animation_player.play("landing")
		
		State.WALL_SLIDING:
			animation_player.play("wall_sliding")
			
		State.WALL_JUMP:
			animation_player.play("jump")
			velocity = WALL_JUMP_VELOCITY
			# 设置墙面的向量
			velocity.x *= get_wall_normal().x
			jump_request_timer.stop()
		
		State.ATTACK_1:
			animation_player.play("attack_1")
			is_combo_requested = false
		
		State.ATTACK_2:
			animation_player.play("attack_2")
			is_combo_requested = false
		
		State.ATTACK_3:
			animation_player.play("attack_3")
			is_combo_requested = false
		
		State.HURT:
			animation_player.play("hurt")
			# 进行扣血， 执行击退效果
			stats.health -= pending_damage.amount
			# 方向  伤害来源位置指向自己位置
			var dir := pending_damage.source.global_position.direction_to(global_position)
			velocity = dir * KNOCBACK_AMOUNT
			# 玩家不需要调整切图方向
			
			pending_damage = null
			# 受到伤害，打开无敌2s	
			invincible_timer.start()
			
		State.DYING:
			animation_player.play("die")
			# 死亡暂停无敌2s闪光
			invincible_timer.stop()
		
		State.SLIDING_START:
			animation_player.play("sliding_start")
		
		State.SLIDING_LOOP:
			animation_player.play("sliding_loop")
		
		State.SLIDING_END:
			animation_player.play("sliding_end")
			
	# 进入蹬墙跳 降低运动速度 子弹时间
	#if to == State.WALL_JUMP:
		#Engine.time_scale = 0.3
	#if from == State.WALL_JUMP:
		#Engine.time_scale = 1.0
		
	# 设置为第一帧
	is_first_tick = true

# 受到攻击
func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	# 无敌跳出伤害
	if invincible_timer.time_left>0:
		return
		
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
