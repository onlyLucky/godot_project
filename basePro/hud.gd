extends CanvasLayer

signal start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 显示临时消息
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# 显示玩家死亡情况
func show_game_over():
	show_message("Game Over")
	# 等待消息计时器倒计时
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# 做一个一次性计时器，等它完成。
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

#更新分数代码
func update_score(score):
	$ScoreLabel.text = str(score)
	


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
