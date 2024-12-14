extends HBoxContainer
# 用户血量信息面板

# 血量
@export var stats: Stats
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var eased_health_bar: TextureProgressBar = $HealthBar/EasedHealthBar

func _ready() -> void:
	stats.health_changed.connect(unpdate_health)
	# 手动调用 第一次初始化血量
	unpdate_health()

func unpdate_health() -> void:
	var percentage := stats.health / float(stats.max_health)
	health_bar.value = percentage

	create_tween().tween_property(eased_health_bar, "value", percentage, 0.3)
