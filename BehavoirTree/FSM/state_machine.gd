extends Node

@export var initial_state: NodePath;
@export var auto_start: bool = true;

var current_state: StateBase;

@onready var states = get_children()

func _ready() -> void:
	if auto_start:
		launch()
		
func _physisc_process(delta):
	if current_state.has_method("physics_update"):
		current_state.physics_update(delta)
		
func _process(delta):
	if current_state.has_method("update"):
		current_state.update(delta)

# 状态机

# 启动状态机
func launch() -> void:
	assert(initial_state != null, "初始状态不能为空")
	current_state = get_node(initial_state)
	current_state.enter()
  
# 添加状态
# 删除状态

# 是否存在状态
func has_state(state_name: String)->bool:
	for s in states:
		if "state_name" in s and s.state_name == state_name:
			return true
	return false

# 获取状态 (其实两者可以合并 判断是否存在，存在返回StateBase 不存在返回false)
func get_state(state_name: String)->StateBase:
	for s in states:
		if "state_name" in s and s.state_name == state_name:
			return s
	return null

# 切换状态
func transition_to(state_name: String, msg: Dictionary = {}):
	if has_state(state_name):
		var state: StateBase = get_state(state_name)
		if state:
			current_state.exit()
			current_state = state
			current_state.enter(msg)
