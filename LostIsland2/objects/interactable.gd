@tool
extends Area2D

class_name Interactable

signal interact

# 当前是否允许 接受道具
@export var allow_item := false
@export var texture: Texture:
	set(v):
		texture = v
		print("set_texture texture1")
		set_texture(v)

func _input_event(viewport, event, shape_idx):
	if !event.is_action_pressed("interact"):
		return
	if ! allow_item and Game.inventory.active_item:
		return
	_interact()
	

func _interact():
	interact.emit() # emit_signal("interact")

func set_texture(v: Texture):
	#print("set_texture", v)
	
	# 判断后面创建节点是否存在
	for node in get_children():
		# 判断当前是否为编译器创建的节点
		if node.owner == null:
			node.queue_free()
	#texture = v
	if texture == null:
		return
	# 2D纹理图片
	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
	# 添加节点碰撞区域
	var rect := RectangleShape2D.new()
	rect.size = v.get_size()
	# 添加实际碰撞区域
	var collider := CollisionShape2D.new()
	collider.shape = rect
	add_child(collider)
	
