extends Area2D

var travelled_distance = 0

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	# 超出范围子弹消失
	if travelled_distance > RANGE:
		queue_free()

# 子弹击中敌人
func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
