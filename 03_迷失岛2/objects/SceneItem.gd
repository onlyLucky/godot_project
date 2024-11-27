@tool
extends Interactable
class_name SceneItem

@export var item: Item:
	set(v):
		item = v
		set_item(v)

func _ready():
	# 这里是工具脚本， 所以在编译器中打开场景就不执行后面的逻辑了
	if Engine.is_editor_hint():
		return
	if Game.flags.has(_get_flag()):
		queue_free()

func set_item(v: Item):
	# 判断item 是否为空 非空 item.scene_texture 空的话 null
	texture = item.scene_texture if item else null
	#set_texture(item.scene_texture if item else null)
	
	# 手动要求检查器更新全部属性
	notify_property_list_changed()
	
func _interact():
	super()
	
	# 拾取道具添加flag
	Game.flags.add(_get_flag())
	# 拾取道具添加道具栏
	Game.inventory.add_item(item)
	
	# 添加道具消失过渡动画（添加动画，注意重复点击，这里是定义一个sprite2d 动画结束，sprite2d再消失）
	var sprite := Sprite2D.new()
	sprite.texture = item.scene_texture
	get_parent().add_child(sprite)
	sprite.global_position = global_position
	
	# 创建补间动画 反方向变大再缩小
	var tween := sprite.create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.15)
	tween.tween_callback(sprite.queue_free)
	
	queue_free()
	
func _get_flag():
	return "picked:" + item.resource_path.get_file()

