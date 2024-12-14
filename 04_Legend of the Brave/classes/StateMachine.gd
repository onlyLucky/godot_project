class_name StateMachine
# player 播放动作 状态机
extends Node

# 保留当前状态
const KEEP_CURRENT := -1

# 当前状态 设置吗，，默认值为-1（因为enum默认为0 _ready设置current_state = 0 这里也会收到 from 0  to 0  就很奇怪）
var current_state: int = -1:
	set(v):
		# owner 为当前场景的根节点 调用 Player 里面 transition_state函数
		owner.transition_state(current_state, v)
		current_state = v
		state_time = 0

# 运动状态持续时间
var state_time: float

# _ready 调用的逻辑是 场景的所有子节点都ready 后 父节点最后在进行ready
func _ready() -> void:
	# 这里等待Player ready信号加载完，因为current_state = 0 会触发 set  owner.transition_state, 上面提到ready加载方式，当前肯定还未加载到owner
	await owner.ready
	current_state = 0


# 物理帧运行
func _physics_process(delta: float) -> void:
	while true:
		# Play 设置下一个 状态动画
		var next := owner.get_next_state(current_state) as int
		# 判断当前状态动画是否改变
		if next == KEEP_CURRENT:
			break
		# 切换状态动画
		current_state = next
	# 代替原有的_physics_process
	owner.tick_physics(current_state,delta)
	state_time += delta
