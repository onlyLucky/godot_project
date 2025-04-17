extends StateBase

@export var wait_time: float = 2.0;

func _ready():
	state_name = "state_1_eat"

# 每一帧更新
func update(delta) -> void:
	pass

# 每一个物理帧更新
func physics_update(delta) -> void:
	pass

func enter(msg: Dictionary={}) -> void:
	print_debug("enter state 1 eat")
	await get_tree().create_timer(wait_time, false).timeout
	#父级 root/FSM 状态机
	owner.transition_to("state_2_sleep", {"wait_time" : wait_time})


func exit() -> void:
	print_debug("exit state 1 eat")
