extends HBoxContainer
# 用户血量信息面板

# 血量
@export var stats: Stats

@onready var health_bar: TextureProgressBar = $V/HealthBar
@onready var eased_health_bar: TextureProgressBar = $V/HealthBar/EasedHealthBar
@onready var energy_bar: TextureProgressBar = $V/EnergyBar


func _ready() -> void:
	if not stats:
		stats = Game.player_stats
	
	stats.health_changed.connect(unpdate_health)
	# 手动调用 第一次初始化血量
	unpdate_health(true)
	
	stats.energy_changed.connect(update_energy)
	# 手动调用 第一次初能量条
	update_energy()

func unpdate_health(skip_anim := false) -> void:
	var percentage := stats.health / float(stats.max_health)
	health_bar.value = percentage
	
	if skip_anim:
		eased_health_bar.value = percentage
	else:
		create_tween().tween_property(eased_health_bar, "value", percentage, 0.3)


func update_energy() -> void:
	var percentage := stats.energy / stats.max_energy
	energy_bar.value = percentage
