extends Control

@onready var _10_comm: ColorRect = $"10Comm"

func _ready() -> void:
	# 设置材质 shader 参数
	_10_comm.material.set_shader_parameter("value",Color(1.0,0.0,0.0,1.0))
	
	# 添加过渡 
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_10_comm,"material:shader_param/iTime",1.0,0.2)

# 每一帧执行
"""
func _process(delta: float) -> void:
	var mouse_pos = _10_comm.get_global_mouse_position()
	
	_10_comm.material.set_shader_parameter("iMouse",Color(mouse_pos.x/1024.,mouse_pos.y/600.,0.0,0.0))
"""
