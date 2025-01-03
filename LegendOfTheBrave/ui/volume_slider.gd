extends HSlider

# 音量控制场景

@export var bus: StringName = "Master"

@onready var bus_index := AudioServer.get_bus_index(bus)

func _ready() -> void:
	value = SoundManger.get_volume(bus_index)
	
	# 滑块改变的时候
	value_changed.connect(func (v: float):
		SoundManger.set_volum(bus_index, v)
		Game.save_config()	
	)
	
	SoundManger.play_bgm(preload("res://assets/bgm/02 1 titles LOOP.mp3"))
