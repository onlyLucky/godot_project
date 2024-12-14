class_name Enemy
extends CharacterBody2D

#敌人类 公用属性
enum Direction {
	LEFT = -1,
	RIGHT = +1
}

@export var direction := Direction.LEFT:
	set(v):
		direction = v
		# @export 比 @onready 要早，这里等待 ready 信号
		if not is_node_ready():
			await ready
		graphics.scale.x = -direction # 图片向左

# 最大速度
@export var max_speed: float = 100
# 加速度
@export var acceleration: float = 2000

# 获取默认加速度
var default_gravity := ProjectSettings.get("physics/2d/default_gravity") as float

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var stats: Stats = $Stats


# 移动速度
func move(speed: float, delta:float) -> void:
	velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
	velocity.y += default_gravity * delta
	
	# 开始移动
	move_and_slide()


func die() -> void:
	queue_free()
