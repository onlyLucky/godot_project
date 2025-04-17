extends StateBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_name = "state_2_sleep"

func enter(msg: Dictionary={})-> void:
	print_debug("enter state2 sleep")
	print_debug("from eat time params: ", msg["wait_time"])
