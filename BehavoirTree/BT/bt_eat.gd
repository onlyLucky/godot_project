extends Node
class_name BTEat

signal successed
signal failed

func run():
	if owner.is_hunger:
		print_debug("BT 饥饿++, 开始吃饭")
		await get_tree().create_timer(2).timeout
		owner.is_hunger = false
		print("BT 吃完饭了")
	else:
		print_debug("BT 还不是很饿")
		failed.emit()
	
