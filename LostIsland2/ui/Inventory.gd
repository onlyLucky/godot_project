extends VBoxContainer

var _hand_outro: Tween 
var _label_outro: Tween

@onready var label = $Label
@onready var prev = $ItemBar/Prev
@onready var prop = $ItemBar/Use/Prop
@onready var hand = $ItemBar/Use/Hand
@onready var next = $ItemBar/Next
@onready var timer = $Label/Timer

func _ready():
	# 测试 添加道具到背包中
	#Game.inventory.add_item(preload("res://items/key.tres"))
	#Game.inventory.add_item(preload("res://items/mail.tres"))
	
	# 初始化 当前道具 选中 手状态
	hand.hide()
	hand.modulate.a = 0.0
	# 初始化 道具描述 label
	label.hide()
	label.modulate.a = 0.0
	
	# 连接背包 changed 信号， 更改ui
	Game.inventory.connect("changed", Callable(self, "_update_ui"))
	_update_ui(true)

# 事件入口
func _input(event):
	if event.is_action_pressed("interact") and Game.inventory.active_item:
		# 当前帧结束之后，将active_item 设置值为空
		Game.inventory.set_deferred("active_item", null)
		
		# hand 消失动画过渡
		_hand_outro = create_tween()
		# set_parallel设置后面Tween 并行执行
		_hand_outro.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
		_hand_outro.tween_property(hand, "scale", Vector2.ONE*3, 0.15)
		_hand_outro.tween_property(hand, "modulate:a", 0.0, 0.15)
		#chain 设置前面tween动画过渡完成之后执行
		_hand_outro.chain().tween_callback(hand.hide)
	
# 更新道具背包界面
func _update_ui(is_init := false):
	var count := Game.inventory.get_item_count()
	prev.disabled = count < 2
	next.disabled = count < 2
	
	visible = count > 0
	
	var item := Game.inventory.get_current_item()
	if !item:
		return
	
	label.text = item.description
	prop.texture = item.prop_texture
	
	# 是否为初始化加载，不进行动画过渡
	if is_init:
		return
	# 添加缓动动画
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(prop,"scale",Vector2.ONE, 0.15).from(Vector2.ZERO)
	
	_show_label()


#显示 道具描述label
func _show_label():
	if _label_outro and _label_outro.is_valid():
		_label_outro.kill()
		_label_outro = null
	label.show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_callback(timer.start)

# 上一个点击
func _on_prev_pressed():
	Game.inventory.select_prev()


# 下一个点击
func _on_next_pressed():
	Game.inventory.select_next()

# 当前道具点击
func _on_use_pressed():
	Game.inventory.active_item = Game.inventory.get_current_item()
	
	# 检测动画过渡是否完成
	if _hand_outro and _hand_outro.is_valid():
		_hand_outro.kill()
		_hand_outro = null
	hand.show()
	# 手显示 过渡动画
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_property(hand, "scale", Vector2.ONE, 0.15).from(Vector2.ZERO)
	# modulate:a 是透明度
	tween.tween_property(hand, "modulate:a", 1.0, 0.15)
	
	_show_label()
	

# 道具描述 label 消失动画过渡
func _on_timer_timeout():
	_label_outro = create_tween()
	_label_outro.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_label_outro.tween_property(label, "modulate:a", 0.0, 0.2)
	_label_outro.tween_callback(label.hide)
