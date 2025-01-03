extends Area2D

signal hit

@export var speed = 400 # player 移动速度 pixels/sec
var screen_size #游戏窗口大小

# 当节点进入场景树
func _ready():
	# get_node(".") 获取根节点
	screen_size = get_viewport_rect().size
	# $CollisionShape2D.get_shape().get_rect()
	print("hello Godot")
	hide()


# 在每一帧都被调用 delta 参数是 帧长度 ——完成上一帧所花费的时间
func _process(delta):
	var velocity = Vector2.ZERO # 默认不移动 向量
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $ 是 get_node() 的简写。 get_node("AnimatedSprite2D")
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# 设置移动动画
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		# flip_v 属性将这个动画进行垂直翻转
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	
	# 设置定位
	position += velocity * delta
	# clamp 一个值意味着将其限制在给定范围内
	position = position.clamp(Vector2.ZERO, screen_size)

# 禁用玩家的碰撞检测,确保我们不会多次触发 hit 信号。
func _on_body_entered(body):
	print("_on_body_entered")
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
# 开始新游戏时调用来重置玩家
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


