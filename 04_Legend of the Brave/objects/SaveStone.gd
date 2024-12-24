extends Interactable
# 存档节点逻辑

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# 交互函数
func interact() -> void:
	super()
	
	animation_player.play("activated")
	Game.save_game()

