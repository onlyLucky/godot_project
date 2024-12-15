class_name Stats
# 角色的等级，血量，攻击力，防御力 数值
extends Node

# 血量改变信号
signal health_changed
# 滑铲能量条
signal energy_changed

# 最大血量
@export var max_health: int = 3
# 最大蓝条
@export var max_energy: int = 10
# 每秒回复能量的速度
@export var energy_regen: float = 0.8

# 当前血量 导出变量初始化发生在普通变量初始化之后， 在这里初始化等于导出变量只会等于3 更改节点为5 health也只会等于3,所以加上onready
@onready var health: int = max_health:
	set(v):
		# clampi 设置最大值 最小值
		v = clampi(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()
	
@onready var energy: float = max_energy:
	set(v):
		# clampi 设置最大值 最小值
		v = clampf(v, 0, max_energy)
		if energy == v:
			return
		energy = v
		energy_changed.emit()

func _process(delta: float) -> void:
	energy += energy_regen * delta
