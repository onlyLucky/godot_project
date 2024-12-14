extends Node

# 允许我们选择要实例化的 Mob 场景
@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 游戏结束
func game_over():
	print("game_over")
	$ScoreTimer.stop()
	$MobTimer.stop()
	# 调用显示面板结束游戏
	$HUD.show_game_over()
	# 音乐逻辑
	$Music.stop()
	$DeathSound.play()

# 开始新游戏
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	# 更新分数显示并显示“Get Ready”消息
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	# call_group() 函数调用组中每个节点上的删除函数——让每个怪物删除其自身
	get_tree().call_group("mobs","queue_free")
	# 添加音乐
	$Music.play()

# 分数计算
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


# 开始游戏定时器
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start() # Replace with function body.


func _on_mob_timer_timeout():
	# 创建小怪实例
	var mob = mob_scene.instantiate()
	
	# 在Path2D选择一个随机的位置
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# 设置垂直于路径方向的方向
	var direction = mob_spawn_location.rotation + PI / 2
	
	# 设置敌人随机位置
	mob.position = mob_spawn_location.position

	# 添加随机角度
	direction += randf_range(-PI / 4,PI / 4)
	mob.rotation = direction

	# 添加一个随机速度
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# 添加mob到主场景
	add_child(mob)

